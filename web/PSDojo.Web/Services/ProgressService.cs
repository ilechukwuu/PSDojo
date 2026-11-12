using System.Text.Json;
using PSDojo.Web.Content;
using PSDojo.Web.Data;

namespace PSDojo.Web.Services;

public sealed record ExerciseState(ExerciseInfo Exercise, string State, IReadOnlyList<string> Missing, ProgressRecord Record);

public sealed record QuizResult(bool Passed, int Total, int Correct, int Score, int PassMark, IReadOnlyList<int> Wrong);

public sealed record ImportResult(bool Accepted, string Error, int Matched, int NewlyCompleted, int Ignored);

public sealed class ProgressService(ContentStore content, IDojoStore store)
{
    public const int HintLevels = 3;

    public async Task<IReadOnlyList<ExerciseState>> GetStatesAsync(long userId)
    {
        var approved = content.Approved;
        var records = (await store.GetProgressAsync(userId)).ToDictionary(record => record.ExerciseId);
        return BuildStates(approved, records);
    }

    public static IReadOnlyList<ExerciseState> BuildStates(IReadOnlyList<ExerciseInfo> approved, IReadOnlyDictionary<string, ProgressRecord> records)
    {
        var known = approved.Select(exercise => exercise.Id).ToHashSet();
        var done = approved.Where(exercise => records.TryGetValue(exercise.Id, out var record) && record.IsCompleted)
            .Select(exercise => exercise.Id)
            .ToHashSet();
        var states = new List<ExerciseState>();
        foreach (var exercise in approved)
        {
            var missing = exercise.Prerequisites.Where(id => known.Contains(id) && !done.Contains(id)).ToList();
            var state = done.Contains(exercise.Id) ? "completed" : missing.Count > 0 ? "locked" : "open";
            states.Add(new ExerciseState(exercise, state, missing, records.GetValueOrDefault(exercise.Id) ?? ProgressRecord.Empty(exercise.Id)));
        }
        return states;
    }

    public async Task<ExerciseState?> GetStateAsync(long userId, string exerciseId) =>
        (await GetStatesAsync(userId)).FirstOrDefault(state => state.Exercise.Id == exerciseId);

    public async Task<(int Level, string De, string En)> NextHintAsync(long userId, ExerciseState state)
    {
        var (de, en) = content.Hints(state.Exercise);
        var level = Math.Min(state.Record.Hints + 1, HintLevels);
        if (!state.Record.IsCompleted && state.Record.Hints < HintLevels)
        {
            await store.SaveProgressAsync(userId, state.Record with { Hints = level, Source = "web" });
        }
        return (level, de[level - 1], en[level - 1]);
    }

    public async Task<string?> ViewSolutionAsync(long userId, ExerciseState state)
    {
        if (state.Record.Hints < HintLevels)
        {
            return null;
        }
        if (!state.Record.IsCompleted && !state.Record.SolutionViewed)
        {
            await store.SaveProgressAsync(userId, state.Record with { SolutionViewed = true, Source = "web" });
        }
        return content.ReadFile(state.Exercise, "solution.ps1");
    }

    public async Task<QuizResult> GradeQuizAsync(long userId, ExerciseState state, IReadOnlyDictionary<string, string> answers)
    {
        var questions = content.Quiz(state.Exercise);
        var wrong = new List<int>();
        foreach (var question in questions)
        {
            var given = answers.GetValueOrDefault(question.Id.ToString(System.Globalization.CultureInfo.InvariantCulture)) ?? "";
            if (!string.Equals(given.Trim(), question.Answer, StringComparison.OrdinalIgnoreCase))
            {
                wrong.Add(question.Id);
            }
        }
        var correct = questions.Count - wrong.Count;
        var score = questions.Count == 0 ? 0 : (int)Math.Floor(100.0 * correct / questions.Count);
        var passed = questions.Count > 0 && score >= state.Exercise.PassMark;
        if (!state.Record.IsCompleted)
        {
            var record = state.Record with { Attempts = state.Record.Attempts + 1, Source = "web" };
            if (passed)
            {
                record = record with { Status = "completed", CompletedAt = DateTime.UtcNow.ToString("o") };
            }
            await store.SaveProgressAsync(userId, record);
        }
        return new QuizResult(passed, questions.Count, correct, score, state.Exercise.PassMark, wrong);
    }

    public async Task RecordCheckAsync(long userId, ExerciseState state, bool passed)
    {
        if (state.Record.IsCompleted)
        {
            return;
        }
        var record = state.Record with { Attempts = state.Record.Attempts + 1, Source = "web" };
        if (passed)
        {
            record = record with { Status = "completed", CompletedAt = DateTime.UtcNow.ToString("o") };
        }
        await store.SaveProgressAsync(userId, record);
    }

    public async Task<ImportResult> ImportReportAsync(long userId, JsonElement report)
    {
        if (report.ValueKind != JsonValueKind.Object
            || !report.TryGetProperty("kind", out var kind)
            || kind.GetString() != "PSDojoReport"
            || !report.TryGetProperty("exercises", out var items)
            || items.ValueKind != JsonValueKind.Array)
        {
            return new ImportResult(false, "not_a_report", 0, 0, 0);
        }

        var approved = content.Approved.ToDictionary(exercise => exercise.Id);
        var existing = (await store.GetProgressAsync(userId)).ToDictionary(record => record.ExerciseId);
        var matched = 0;
        var newlyCompleted = 0;
        var ignored = 0;
        foreach (var item in items.EnumerateArray())
        {
            var id = item.TryGetProperty("id", out var idValue) && idValue.ValueKind == JsonValueKind.String ? idValue.GetString() ?? "" : "";
            if (!approved.ContainsKey(id))
            {
                ignored++;
                continue;
            }
            matched++;
            var current = existing.GetValueOrDefault(id) ?? ProgressRecord.Empty(id);
            var reportedDone = Text(item, "status") == "completed";
            var merged = current with
            {
                Attempts = Math.Max(current.Attempts, Number(item, "attempts")),
                Hints = Math.Min(HintLevels, Math.Max(current.Hints, Number(item, "hints"))),
                SolutionViewed = current.SolutionViewed || (item.TryGetProperty("solutionViewed", out var viewed) && viewed.ValueKind == JsonValueKind.True),
                Seconds = Math.Max(current.Seconds, Number(item, "seconds")),
            };
            if (reportedDone && !current.IsCompleted)
            {
                var completedAt = Text(item, "completedAt");
                merged = merged with
                {
                    Status = "completed",
                    CompletedAt = completedAt.Length > 0 ? completedAt : DateTime.UtcNow.ToString("o"),
                    Source = "import",
                };
                newlyCompleted++;
            }
            if (merged != current)
            {
                await store.SaveProgressAsync(userId, merged);
            }
        }
        return new ImportResult(true, "", matched, newlyCompleted, ignored);
    }

    private static int Number(JsonElement item, string name) =>
        item.TryGetProperty(name, out var value) && value.ValueKind == JsonValueKind.Number && value.TryGetInt32(out var number) ? Math.Max(0, number) : 0;

    private static string Text(JsonElement item, string name) =>
        item.TryGetProperty(name, out var value) && value.ValueKind == JsonValueKind.String ? value.GetString() ?? "" : "";
}
