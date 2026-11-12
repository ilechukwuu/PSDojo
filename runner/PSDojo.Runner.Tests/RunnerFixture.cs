using System.Diagnostics;
using System.Net.Http.Json;
using System.Text;
using System.Text.Json;
using System.Text.RegularExpressions;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc.Testing;

namespace PSDojo.Runner.Tests;

public sealed class RunnerFixture : WebApplicationFactory<RunnerEntryPoint>
{
    public const string Secret = "test-secret-for-the-runner";
    public const string Image = "psdojo-runner:latest";

    private readonly string _workFolder = Path.Combine(Path.GetTempPath(), "psdojo-runner-tests", Guid.NewGuid().ToString("N"));

    public RunnerFixture()
    {
        var (exitCode, _) = Docker("image", "inspect", Image);
        if (exitCode != 0)
        {
            throw new InvalidOperationException($"The image {Image} does not exist or Docker is not running. Build it with runner/Build-RunnerImage.ps1 before running the runner tests.");
        }
        ContentPath = Path.Combine(_workFolder, "content");
        CopyContent(Path.Combine(RepoRoot, "content"), ContentPath);
        Client = CreateClient();
        Client.Timeout = TimeSpan.FromSeconds(90);
        Client.DefaultRequestHeaders.Add("X-Runner-Secret", Convert.ToBase64String(Encoding.UTF8.GetBytes(Secret)));
    }

    public string ContentPath { get; }

    public HttpClient Client { get; }

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

    public static (int ExitCode, string Output) Docker(params string[] arguments)
    {
        var startInfo = new ProcessStartInfo("docker") { RedirectStandardOutput = true, RedirectStandardError = true, UseShellExecute = false };
        foreach (var argument in arguments)
        {
            startInfo.ArgumentList.Add(argument);
        }
        try
        {
            using var process = Process.Start(startInfo)!;
            var output = process.StandardOutput.ReadToEnd() + process.StandardError.ReadToEnd();
            process.WaitForExit();
            return (process.ExitCode, output);
        }
        catch (System.ComponentModel.Win32Exception)
        {
            return (-1, "docker was not found");
        }
    }

    public static string[] LeftoverContainers() =>
        Docker("ps", "--all", "--filter", "name=psdojo-", "--format", "{{.Names}}").Output
            .Split('\n', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries);

    public async Task<JsonElement> RunAsync(string code, string mode = "run", string exerciseId = "m01-e01")
    {
        var response = await Client.PostAsJsonAsync("/run", new { mode, code, exerciseId });
        var text = await response.Content.ReadAsStringAsync();
        Assert.True(response.IsSuccessStatusCode, $"runner answered {(int)response.StatusCode}: {text}");
        return JsonDocument.Parse(text).RootElement.Clone();
    }

    public string ReadContent(string relativePath) => File.ReadAllText(Path.Combine(ContentPath, relativePath), Encoding.UTF8);

    protected override void ConfigureWebHost(IWebHostBuilder builder)
    {
        builder.UseEnvironment("Testing");
        builder.UseSetting("Runner:SharedSecret", Secret);
        builder.UseSetting("Runner:ContentPath", ContentPath);
        builder.UseSetting("Runner:Image", Image);
        builder.UseSetting("Runner:WorkRoot", Path.Combine(_workFolder, "jobs"));
    }

    protected override void Dispose(bool disposing)
    {
        base.Dispose(disposing);
        try
        {
            Directory.Delete(_workFolder, true);
        }
        catch (IOException)
        {
            return;
        }
    }

    private static void CopyContent(string source, string target)
    {
        Directory.CreateDirectory(target);
        foreach (var folder in Directory.GetDirectories(source, "*", SearchOption.AllDirectories))
        {
            Directory.CreateDirectory(folder.Replace(source, target));
        }
        foreach (var file in Directory.GetFiles(source, "*", SearchOption.AllDirectories))
        {
            var top = Path.GetRelativePath(source, file).Split(Path.DirectorySeparatorChar)[0];
            if (top != "m01" && !top.StartsWith('_'))
            {
                continue;
            }
            var destination = file.Replace(source, target);
            if (Path.GetFileName(file) != "meta.json")
            {
                File.Copy(file, destination, true);
                continue;
            }
            var id = Path.GetFileName(Path.GetDirectoryName(file)!);
            var status = id == "m01-e07" ? "draft" : "approved";
            var text = Regex.Replace(File.ReadAllText(file, Encoding.UTF8), "\"status\"\\s*:\\s*\"[a-z]+\"", $"\"status\": \"{status}\"");
            File.WriteAllText(destination, text, new UTF8Encoding(false));
        }
    }
}

[CollectionDefinition("runner")]
public sealed class RunnerCollection : ICollectionFixture<RunnerFixture>;
