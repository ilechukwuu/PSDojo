using System.Net.Http.Json;
using System.Text;
using System.Text.Json;
using System.Text.RegularExpressions;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.AspNetCore.TestHost;
using Microsoft.Extensions.DependencyInjection;
using PSDojo.Web.Data;
using PSDojo.Web.Execution;

namespace PSDojo.Web.Tests;

public sealed class DojoFactory : WebApplicationFactory<Program>
{
    private readonly Dictionary<string, string> _settings = new();
    private readonly string _workFolder;
    private IRunnerClient? _runner;

    public DojoFactory(string[]? approved = null, string[]? reviewed = null, bool approveAll = false)
    {
        _workFolder = Path.Combine(Path.GetTempPath(), "psdojo-web-tests", Guid.NewGuid().ToString("N"));
        ContentPath = Path.Combine(_workFolder, "content");
        CopyContent(Path.Combine(RepoRoot, "content"), ContentPath, approved ?? [], reviewed ?? [], approveAll);
        _settings["Content:Path"] = ContentPath;
        _settings["Database:ConnectionString"] = $"Data Source={Path.Combine(_workFolder, "test.db")}";
        _settings["Auth:Admins:0"] = "admin";
    }

    public string ContentPath { get; }

    public static string RepoRoot
    {
        get
        {
            var folder = new DirectoryInfo(AppContext.BaseDirectory);
            while (folder is not null && !(Directory.Exists(Path.Combine(folder.FullName, "content")) && Directory.Exists(Path.Combine(folder.FullName, "module"))))
            {
                folder = folder.Parent;
            }
            return folder?.FullName ?? throw new InvalidOperationException("Repository root not found.");
        }
    }

    public DojoFactory WithSetting(string key, string value)
    {
        _settings[key] = value;
        return this;
    }

    public DojoFactory WithRunner(IRunnerClient runner)
    {
        _runner = runner;
        return this;
    }

    public IDojoStore Store => Services.GetRequiredService<IDojoStore>();

    public async Task<HttpClient> LoginAsync(string name)
    {
        var client = CreateClient(new WebApplicationFactoryClientOptions { HandleCookies = true, AllowAutoRedirect = false });
        client.DefaultRequestHeaders.Add("X-PSDojo-Request", "1");
        var response = await client.PostAsJsonAsync("/api/login", new { name });
        response.EnsureSuccessStatusCode();
        return client;
    }

    public HttpClient Anonymous()
    {
        var client = CreateClient(new WebApplicationFactoryClientOptions { HandleCookies = true, AllowAutoRedirect = false });
        client.DefaultRequestHeaders.Add("X-PSDojo-Request", "1");
        return client;
    }

    public async Task<HttpClient> LoginWithRoleAsync(string name, string role)
    {
        var client = await LoginAsync(name);
        await Store.SetUserRoleAsync(name, role);
        return client;
    }

    public string ReadContent(string relativePath) => File.ReadAllText(Path.Combine(ContentPath, relativePath), Encoding.UTF8);

    protected override void ConfigureWebHost(IWebHostBuilder builder)
    {
        builder.UseEnvironment("Testing");
        foreach (var setting in _settings)
        {
            builder.UseSetting(setting.Key, setting.Value);
        }
        if (_runner is not null)
        {
            builder.ConfigureTestServices(services =>
            {
                services.AddSingleton(_runner);
            });
        }
    }

    protected override void Dispose(bool disposing)
    {
        base.Dispose(disposing);
        Microsoft.Data.Sqlite.SqliteConnection.ClearAllPools();
        try
        {
            Directory.Delete(_workFolder, true);
        }
        catch (IOException)
        {
            return;
        }
    }

    private static void CopyContent(string source, string target, string[] approved, string[] reviewed, bool approveAll)
    {
        foreach (var folder in Directory.GetDirectories(source, "*", SearchOption.AllDirectories))
        {
            Directory.CreateDirectory(folder.Replace(source, target));
        }
        Directory.CreateDirectory(target);
        foreach (var file in Directory.GetFiles(source, "*", SearchOption.AllDirectories))
        {
            var destination = file.Replace(source, target);
            if (Path.GetFileName(file) != "meta.json")
            {
                File.Copy(file, destination, true);
                continue;
            }
            var id = Path.GetFileName(Path.GetDirectoryName(file)!);
            var status = approveAll || approved.Contains(id) ? "approved" : reviewed.Contains(id) ? "reviewed" : "draft";
            var text = Regex.Replace(File.ReadAllText(file, Encoding.UTF8), "\"status\"\\s*:\\s*\"[a-z]+\"", $"\"status\": \"{status}\"");
            File.WriteAllText(destination, text, new UTF8Encoding(false));
        }
    }
}

public static class HttpExtensions
{
    public static async Task<JsonElement> JsonAsync(this HttpResponseMessage response)
    {
        var text = await response.Content.ReadAsStringAsync();
        return JsonDocument.Parse(text.Length == 0 ? "{}" : text).RootElement.Clone();
    }

    public static Task<HttpResponseMessage> PostAsync(this HttpClient client, string url, object body) =>
        client.PostAsJsonAsync(url, body);
}

public sealed class FakeRunner : IRunnerClient
{
    public List<RunnerRequest> Requests { get; } = [];

    public bool Passes { get; set; } = true;

    public bool IsConfigured => true;

    public Task<RunnerResult> ExecuteAsync(RunnerRequest request, CancellationToken cancellationToken)
    {
        Requests.Add(request);
        var result = request.Mode == "run"
            ? new RunnerResult(true, "ok", "fake output", false, 0, 0, "", "", "", "", "", "", 0, [])
            : Passes
                ? new RunnerResult(true, "ok", "", true, 3, 3, "Passed", "", "", "", "", "", 0, [])
                : new RunnerResult(true, "ok", "", false, 3, 1, "TestFailed", "a test", "4", "3", "because", "", 0, ["a test"]);
        return Task.FromResult(result);
    }
}
