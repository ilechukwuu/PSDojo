using System.Text;
using System.Text.Json;
using System.Text.Json.Nodes;
using Markdig;
using Microsoft.Extensions.Options;

namespace PSDojo.Web.Content;

/// <summary>
/// Reads the shared content folder. The folder contract is documented at the top of
/// module/PSDojo/Private/Content.ps1 and is the single source of truth for both front ends.
/// </summary>
public sealed class ContentStore
{
    private static readonly string[] RequiredFiles =
    [
        "meta.json", "lesson.de.md", "lesson.en.md", "task.de.md", "task.en.md",
        "starter.ps1", "solution.ps1", "wrong.ps1", "hints.json", "tests.ps1",
    ];

    private static readonly string[] Types = ["write", "fix", "predict", "refactor", "quiz"];
    private static readonly string[] Statuses = ["draft", "reviewed", "approved"];
    private static readonly TimeSpan CacheTime = TimeSpan.FromSeconds(20);

    private readonly MarkdownPipeline _markdown = new MarkdownPipelineBuilder().DisableHtml().Build();
    private readonly object _gate = new();
    private readonly string _root;
    private ContentSnapshot? _snapshot;
    private DateTime _loadedAt;

    public ContentStore(IOptions<ContentOptions> options, IWebHostEnvironment environment)
    {
        var path = options.Value.Path;
        _root = System.IO.Path.GetFullPath(System.IO.Path.IsPathRooted(path) ? path : System.IO.Path.Combine(environment.ContentRootPath, path));
    }

    public string Root => _root;

    public ContentSnapshot Snapshot
    {
        get
        {
            lock (_gate)
            {
                if (_snapshot is null || DateTime.UtcNow - _loadedAt > CacheTime)
                {
                    _snapshot = Load();
                    _loadedAt = DateTime.UtcNow;
                }
                return _snapshot;
            }
        }
    }

    public void Invalidate()
    {
        lock (_gate)
        {
            _snapshot = null;
        }
    }

    public IReadOnlyList<ExerciseInfo> Approved => Snapshot.Exercises.Where(exercise => exercise.IsApproved).ToList();

    public ExerciseInfo? FindApproved(string id) => Approved.FirstOrDefault(exercise => exercise.Id == id);

    public ExerciseInfo? FindAny(string id) => Snapshot.Exercises.FirstOrDefault(exercise => exercise.Id == id);

    public string ReadFile(ExerciseInfo exercise, string name) =>
        File.ReadAllText(System.IO.Path.Combine(exercise.Path, name), Encoding.UTF8);

    public string RenderMarkdown(string markdown) => Markdown.ToHtml(markdown, _markdown);

    public LocalText RenderPair(ExerciseInfo exercise, string kind) => new(
        RenderMarkdown(ReadFile(exercise, $"{kind}.de.md")),
        RenderMarkdown(ReadFile(exercise, $"{kind}.en.md")));

    public LocalText? ProductionNote(ModuleInfo module)
    {
        var de = System.IO.Path.Combine(module.Path, "production.de.md");
        var en = System.IO.Path.Combine(module.Path, "production.en.md");
        if (!File.Exists(de) || !File.Exists(en))
        {
            return null;
        }
        return new LocalText(RenderMarkdown(File.ReadAllText(de, Encoding.UTF8)), RenderMarkdown(File.ReadAllText(en, Encoding.UTF8)));
    }

    public (IReadOnlyList<string> De, IReadOnlyList<string> En) Hints(ExerciseInfo exercise)
    {
        using var document = JsonDocument.Parse(ReadFile(exercise, "hints.json"));
        return (Strings(document.RootElement, "de"), Strings(document.RootElement, "en"));
    }

    public IReadOnlyList<QuizQuestion> Quiz(ExerciseInfo exercise)
    {
        var file = System.IO.Path.Combine(exercise.Path, "quiz.json");
        if (!File.Exists(file))
        {
            return [];
        }
        using var document = JsonDocument.Parse(File.ReadAllText(file, Encoding.UTF8));
        var questions = new List<QuizQuestion>();
        foreach (var item in document.RootElement.GetProperty("questions").EnumerateArray())
        {
            var options = item.GetProperty("options");
            questions.Add(new QuizQuestion(
                item.GetProperty("id").GetInt32(),
                Text(item, "text"),
                Strings(options, "de"),
                Strings(options, "en"),
                item.GetProperty("answer").GetString() ?? ""));
        }
        return questions;
    }

    public ReviewEntry ApplyReview(ExerciseInfo exercise, string action, string newStatus, string reviewer, string comment)
    {
        lock (_gate)
        {
            var file = System.IO.Path.Combine(exercise.Path, "meta.json");
            var meta = JsonNode.Parse(File.ReadAllText(file, Encoding.UTF8))!.AsObject();
            var entry = new ReviewEntry(action, meta["status"]?.GetValue<string>() ?? "", newStatus, reviewer, DateTime.UtcNow.ToString("o"), comment);
            var history = meta["reviewHistory"] as JsonArray ?? [];
            meta.Remove("reviewHistory");
            history.Add(ToNode(entry));
            meta["status"] = newStatus;
            meta["review"] = ToNode(entry);
            meta["reviewHistory"] = history;
            var normalized = JsonNode.Parse(meta.ToJsonString());
            File.WriteAllText(file, MetaJsonWriter.Write(normalized), new UTF8Encoding(false));
            _snapshot = null;
            return entry;
        }
    }

    private static JsonObject ToNode(ReviewEntry entry) => new()
    {
        ["action"] = entry.Action,
        ["from"] = entry.From,
        ["to"] = entry.To,
        ["reviewer"] = entry.Reviewer,
        ["timestamp"] = entry.Timestamp,
        ["comment"] = entry.Comment,
    };

    private ContentSnapshot Load()
    {
        var modules = new List<ModuleInfo>();
        var exercises = new List<ExerciseInfo>();
        if (!Directory.Exists(_root))
        {
            return new ContentSnapshot(modules, exercises);
        }

        foreach (var folder in Directory.GetDirectories(_root))
        {
            var name = System.IO.Path.GetFileName(folder);
            var file = System.IO.Path.Combine(folder, "module.json");
            if (name.StartsWith('_') || !File.Exists(file))
            {
                continue;
            }
            try
            {
                using var document = JsonDocument.Parse(File.ReadAllText(file, Encoding.UTF8));
                var root = document.RootElement;
                if (root.GetProperty("id").GetString() != name)
                {
                    continue;
                }
                modules.Add(new ModuleInfo(
                    name,
                    root.GetProperty("part").GetInt32(),
                    root.GetProperty("order").GetInt32(),
                    Text(root, "title"),
                    Strings(root, "prerequisites"),
                    OptionalString(root, "kind", "standard"),
                    OptionalString(root, "track", "core"),
                    folder));
            }
            catch (Exception exception) when (exception is JsonException or KeyNotFoundException or InvalidOperationException)
            {
                continue;
            }
        }
        modules = modules.OrderBy(module => module.Order).ThenBy(module => module.Id, StringComparer.Ordinal).ToList();

        foreach (var module in modules)
        {
            foreach (var folder in Directory.GetDirectories(module.Path))
            {
                var exercise = LoadExercise(module, folder);
                if (exercise is not null)
                {
                    exercises.Add(exercise);
                }
            }
        }
        exercises = exercises
            .OrderBy(exercise => exercise.ModuleOrder)
            .ThenBy(exercise => exercise.Order)
            .ThenBy(exercise => exercise.Id, StringComparer.Ordinal)
            .ToList();
        return new ContentSnapshot(modules, exercises);
    }

    private static ExerciseInfo? LoadExercise(ModuleInfo module, string folder)
    {
        var name = System.IO.Path.GetFileName(folder);
        if (name.StartsWith('_') || RequiredFiles.Any(file => !File.Exists(System.IO.Path.Combine(folder, file))))
        {
            return null;
        }
        try
        {
            using var document = JsonDocument.Parse(File.ReadAllText(System.IO.Path.Combine(folder, "meta.json"), Encoding.UTF8));
            var root = document.RootElement;
            var type = root.GetProperty("type").GetString() ?? "";
            var status = root.GetProperty("status").GetString() ?? "";
            if (root.GetProperty("id").GetString() != name
                || root.GetProperty("module").GetString() != module.Id
                || !Types.Contains(type)
                || !Statuses.Contains(status))
            {
                return null;
            }
            if (type == "quiz" && !File.Exists(System.IO.Path.Combine(folder, "quiz.json")))
            {
                return null;
            }
            var passMark = type == "quiz" ? 80 : 100;
            if (root.TryGetProperty("passMark", out var mark) && mark.ValueKind == JsonValueKind.Number)
            {
                passMark = mark.GetInt32();
            }
            var history = new List<ReviewEntry>();
            if (root.TryGetProperty("reviewHistory", out var items) && items.ValueKind == JsonValueKind.Array)
            {
                history.AddRange(items.EnumerateArray().Select(ReadEntry));
            }
            ReviewEntry? review = null;
            if (root.TryGetProperty("review", out var last) && last.ValueKind == JsonValueKind.Object)
            {
                review = ReadEntry(last);
            }
            return new ExerciseInfo(
                name,
                module.Id,
                module.Order,
                Text(root, "title"),
                type,
                root.GetProperty("order").GetInt32(),
                Strings(root, "prerequisites"),
                status,
                Text(root, "concept"),
                passMark,
                root.TryGetProperty("placeholder", out var placeholder) && placeholder.ValueKind == JsonValueKind.True,
                OptionalString(root, "minPowerShell", ""),
                Strings(root, "requires"),
                review,
                history,
                folder);
        }
        catch (Exception exception) when (exception is JsonException or KeyNotFoundException or InvalidOperationException)
        {
            return null;
        }
    }

    private static ReviewEntry ReadEntry(JsonElement element) => new(
        OptionalString(element, "action", ""),
        OptionalString(element, "from", ""),
        OptionalString(element, "to", ""),
        OptionalString(element, "reviewer", ""),
        OptionalString(element, "timestamp", ""),
        OptionalString(element, "comment", ""));

    private static LocalText Text(JsonElement parent, string name)
    {
        var element = parent.GetProperty(name);
        return new LocalText(element.GetProperty("de").GetString() ?? "", element.GetProperty("en").GetString() ?? "");
    }

    private static string OptionalString(JsonElement parent, string name, string fallback) =>
        parent.TryGetProperty(name, out var value) && value.ValueKind == JsonValueKind.String ? value.GetString() ?? fallback : fallback;

    private static IReadOnlyList<string> Strings(JsonElement parent, string name)
    {
        if (!parent.TryGetProperty(name, out var value) || value.ValueKind != JsonValueKind.Array)
        {
            return [];
        }
        return value.EnumerateArray()
            .Where(item => item.ValueKind == JsonValueKind.String)
            .Select(item => item.GetString() ?? "")
            .Where(item => item.Length > 0)
            .ToList();
    }
}
