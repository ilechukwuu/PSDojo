using System.Diagnostics;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using System.Text.RegularExpressions;
using Microsoft.Extensions.Options;

namespace PSDojo.Runner;

public sealed record ExerciseFiles(string Id, string Module, string Folder, string Status);

public sealed partial class ContainerRunner(IOptions<RunnerSettings> options, IHostEnvironment environment, ILogger<ContainerRunner> logger)
{
    private readonly RunnerSettings _settings = options.Value;
    private readonly SemaphoreSlim _slots = new(Math.Max(1, options.Value.MaxConcurrent));

    [GeneratedRegex("^m[0-9]{2}-e[0-9]{2}$")]
    private static partial Regex ExerciseIdPattern();

    public static bool IsValidExerciseId(string id) => ExerciseIdPattern().IsMatch(id);

    public string ContentRoot => Path.GetFullPath(Path.IsPathRooted(_settings.ContentPath)
        ? _settings.ContentPath
        : Path.Combine(environment.ContentRootPath, _settings.ContentPath));

    public ExerciseFiles? FindExercise(string id)
    {
        if (!IsValidExerciseId(id))
        {
            return null;
        }
        var module = id[..3];
        var folder = Path.Combine(ContentRoot, module, id);
        var meta = Path.Combine(folder, "meta.json");
        if (!File.Exists(meta) || !File.Exists(Path.Combine(folder, "tests.ps1")))
        {
            return null;
        }
        try
        {
            using var document = JsonDocument.Parse(File.ReadAllText(meta, Encoding.UTF8));
            var status = document.RootElement.GetProperty("status").GetString() ?? "";
            return new ExerciseFiles(id, module, folder, status);
        }
        catch (Exception exception) when (exception is JsonException or KeyNotFoundException or InvalidOperationException)
        {
            return null;
        }
    }

    public async Task<RunResponse?> ExecuteAsync(string mode, string code, ExerciseFiles exercise, CancellationToken cancellationToken)
    {
        if (!await _slots.WaitAsync(TimeSpan.FromSeconds(_settings.QueueSeconds), cancellationToken))
        {
            return null;
        }
        var workRoot = string.IsNullOrWhiteSpace(_settings.WorkRoot) ? Path.Combine(Path.GetTempPath(), "psdojo-runner") : _settings.WorkRoot;
        var jobFolder = Path.Combine(workRoot, Guid.NewGuid().ToString("N"));
        var containerName = "psdojo-" + Guid.NewGuid().ToString("N");
        try
        {
            PrepareJob(jobFolder, code, exercise, mode);
            var nonce = Convert.ToHexString(RandomNumberGenerator.GetBytes(24));
            var (status, output) = await RunContainerAsync(mode, containerName, jobFolder, nonce, cancellationToken);
            return mode == "check" ? ParseCheck(status, output, nonce) : RunResponse.ForRun(status, output);
        }
        finally
        {
            await RemoveContainerAsync(containerName);
            TryDelete(jobFolder);
            _slots.Release();
        }
    }

    private void PrepareJob(string jobFolder, string code, ExerciseFiles exercise, string mode)
    {
        CreateFolder(jobFolder);
        WriteFile(Path.Combine(jobFolder, "learner.ps1"), code);
        if (mode != "check")
        {
            return;
        }
        var content = Path.Combine(jobFolder, "content");
        var target = Path.Combine(content, exercise.Module, exercise.Id);
        CreateFolder(content);
        CreateFolder(Path.Combine(content, exercise.Module));
        CreateFolder(target);
        foreach (var name in new[] { "meta.json", "tests.ps1", "quiz.json" })
        {
            var source = Path.Combine(exercise.Folder, name);
            if (File.Exists(source))
            {
                CopyFile(source, Path.Combine(target, name));
            }
        }
        var shared = Path.Combine(ContentRoot, "_shared");
        if (Directory.Exists(shared))
        {
            CopyFolder(shared, Path.Combine(content, "_shared"));
        }
    }

    private async Task<(string Status, string Output)> RunContainerAsync(string mode, string containerName, string jobFolder, string nonce, CancellationToken cancellationToken)
    {
        var startInfo = new ProcessStartInfo(_settings.DockerPath)
        {
            RedirectStandardOutput = true,
            RedirectStandardError = true,
            RedirectStandardInput = true,
            UseShellExecute = false,
            CreateNoWindow = true,
        };
        foreach (var argument in DockerArguments.Build(_settings, containerName, jobFolder, mode))
        {
            startInfo.ArgumentList.Add(argument);
        }

        using var process = new Process { StartInfo = startInfo };
        try
        {
            process.Start();
        }
        catch (Exception exception) when (exception is System.ComponentModel.Win32Exception or InvalidOperationException)
        {
            logger.LogError(exception, "Docker could not be started");
            return ("error", "The runner could not start a container.");
        }

        var capture = new CappedOutput(_settings.OutputLimitBytes);
        var readOut = capture.PumpAsync(process.StandardOutput.BaseStream);
        var readError = capture.PumpAsync(process.StandardError.BaseStream);
        try
        {
            if (mode == "check")
            {
                await process.StandardInput.WriteLineAsync(nonce);
            }
            process.StandardInput.Close();
        }
        catch (IOException)
        {
            logger.LogWarning("The container closed its input early");
        }

        var timedOut = false;
        using var timeout = CancellationTokenSource.CreateLinkedTokenSource(cancellationToken);
        timeout.CancelAfter(TimeSpan.FromSeconds(_settings.TimeoutSeconds));
        try
        {
            await process.WaitForExitAsync(timeout.Token);
        }
        catch (OperationCanceledException)
        {
            timedOut = true;
            await KillContainerAsync(containerName);
            try
            {
                process.Kill(true);
            }
            catch (InvalidOperationException)
            {
                logger.LogDebug("The docker client had already exited");
            }
        }
        await Task.WhenAny(Task.WhenAll(readOut, readError), Task.Delay(TimeSpan.FromSeconds(5), CancellationToken.None));

        var status = timedOut ? "timeout" : capture.Truncated ? "truncated" : process.HasExited && process.ExitCode == 137 ? "killed" : "ok";
        return (status, capture.ToString());
    }

    private static RunResponse ParseCheck(string status, string output, string nonce)
    {
        var marker = "PSDOJO-RESULT-" + nonce + " ";
        var line = output.Split('\n').LastOrDefault(item => item.StartsWith(marker, StringComparison.Ordinal));
        if (line is null)
        {
            return status == "timeout"
                ? RunResponse.ForFailedCheck(status, "Timeout", "")
                : RunResponse.ForFailedCheck(status, "EngineError", "The check produced no result.");
        }
        try
        {
            using var document = JsonDocument.Parse(line[marker.Length..]);
            var root = document.RootElement;
            return new RunResponse(
                "ok",
                "",
                root.GetProperty("passed").GetBoolean(),
                root.GetProperty("total").GetInt32(),
                root.GetProperty("passedCount").GetInt32(),
                root.GetProperty("kind").GetString() ?? "",
                root.GetProperty("testName").GetString() ?? "",
                root.GetProperty("expected").GetString() ?? "",
                root.GetProperty("actual").GetString() ?? "",
                root.GetProperty("because").GetString() ?? "",
                root.GetProperty("message").GetString() ?? "",
                root.GetProperty("line").GetInt32(),
                root.GetProperty("failedTests").EnumerateArray().Select(item => item.GetString() ?? "").ToList());
        }
        catch (Exception exception) when (exception is JsonException or KeyNotFoundException or InvalidOperationException)
        {
            return RunResponse.ForFailedCheck(status, "EngineError", "The check result could not be read.");
        }
    }

    private Task KillContainerAsync(string containerName) => RunDockerAsync(["kill", containerName]);

    private Task RemoveContainerAsync(string containerName) => RunDockerAsync(["rm", "--force", "--volumes", containerName]);

    private async Task RunDockerAsync(string[] arguments)
    {
        try
        {
            var startInfo = new ProcessStartInfo(_settings.DockerPath)
            {
                RedirectStandardOutput = true,
                RedirectStandardError = true,
                UseShellExecute = false,
                CreateNoWindow = true,
            };
            foreach (var argument in arguments)
            {
                startInfo.ArgumentList.Add(argument);
            }
            using var process = Process.Start(startInfo);
            if (process is null)
            {
                return;
            }
            using var limit = new CancellationTokenSource(TimeSpan.FromSeconds(20));
            _ = process.StandardOutput.ReadToEndAsync(limit.Token);
            _ = process.StandardError.ReadToEndAsync(limit.Token);
            await process.WaitForExitAsync(limit.Token);
        }
        catch (Exception exception) when (exception is System.ComponentModel.Win32Exception or InvalidOperationException or OperationCanceledException)
        {
            logger.LogWarning(exception, "docker {Command} did not finish", arguments[0]);
        }
    }

    private static void CreateFolder(string path)
    {
        Directory.CreateDirectory(path);
        if (!OperatingSystem.IsWindows())
        {
            File.SetUnixFileMode(path, UnixFileMode.UserRead | UnixFileMode.UserWrite | UnixFileMode.UserExecute | UnixFileMode.GroupRead | UnixFileMode.GroupExecute | UnixFileMode.OtherRead | UnixFileMode.OtherExecute);
        }
    }

    private static void WriteFile(string path, string text)
    {
        File.WriteAllText(path, text, new UTF8Encoding(false));
        MakeReadable(path);
    }

    private static void CopyFile(string source, string target)
    {
        File.Copy(source, target, true);
        MakeReadable(target);
    }

    private static void CopyFolder(string source, string target)
    {
        CreateFolder(target);
        foreach (var file in Directory.GetFiles(source))
        {
            CopyFile(file, Path.Combine(target, Path.GetFileName(file)));
        }
        foreach (var folder in Directory.GetDirectories(source))
        {
            CopyFolder(folder, Path.Combine(target, Path.GetFileName(folder)));
        }
    }

    private static void MakeReadable(string path)
    {
        if (!OperatingSystem.IsWindows())
        {
            File.SetUnixFileMode(path, UnixFileMode.UserRead | UnixFileMode.UserWrite | UnixFileMode.GroupRead | UnixFileMode.OtherRead);
        }
    }

    private void TryDelete(string folder)
    {
        try
        {
            if (Directory.Exists(folder))
            {
                Directory.Delete(folder, true);
            }
        }
        catch (Exception exception) when (exception is IOException or UnauthorizedAccessException)
        {
            logger.LogWarning(exception, "Job folder {Folder} could not be removed", folder);
        }
    }
}

/// <summary>
/// Keeps at most a fixed number of bytes and throws the rest away while still draining the
/// pipe, so a container that prints without end can neither fill memory nor block.
/// </summary>
public sealed class CappedOutput(int limit)
{
    private readonly MemoryStream _buffer = new();
    private readonly object _gate = new();

    public bool Truncated { get; private set; }

    public async Task PumpAsync(Stream stream)
    {
        var chunk = new byte[8192];
        while (true)
        {
            int read;
            try
            {
                read = await stream.ReadAsync(chunk);
            }
            catch (Exception exception) when (exception is IOException or ObjectDisposedException)
            {
                return;
            }
            if (read == 0)
            {
                return;
            }
            lock (_gate)
            {
                var room = limit - (int)_buffer.Length;
                if (room > 0)
                {
                    _buffer.Write(chunk, 0, Math.Min(room, read));
                }
                if (read > room)
                {
                    Truncated = true;
                }
            }
        }
    }

    public override string ToString()
    {
        lock (_gate)
        {
            return Encoding.UTF8.GetString(_buffer.ToArray()).Replace("\r\n", "\n");
        }
    }
}
