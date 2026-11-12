namespace PSDojo.Runner;

public sealed class RunnerSettings
{
    public string SharedSecret { get; set; } = "";
    public string ContentPath { get; set; } = "../../content";
    public string Image { get; set; } = "psdojo-runner:latest";
    public string DockerPath { get; set; } = "docker";
    public string WorkRoot { get; set; } = "";
    public int TimeoutSeconds { get; set; } = 15;
    public int MemoryMb { get; set; } = 384;
    public string Cpus { get; set; } = "1.0";
    public int PidsLimit { get; set; } = 128;
    public int TmpfsMb { get; set; } = 32;
    public int OutputLimitBytes { get; set; } = 65536;
    public int MaxCodeBytes { get; set; } = 100_000;
    public int MaxConcurrent { get; set; } = 4;
    public int QueueSeconds { get; set; } = 10;
}

public sealed record RunRequest(string? Mode, string? Code, string? ExerciseId);

public sealed record RunResponse(
    string Status,
    string Output,
    bool Passed,
    int Total,
    int PassedCount,
    string Kind,
    string TestName,
    string Expected,
    string Actual,
    string Because,
    string Message,
    int Line,
    IReadOnlyList<string> FailedTests)
{
    public static RunResponse ForRun(string status, string output) =>
        new(status, output, false, 0, 0, "", "", "", "", "", "", 0, []);

    public static RunResponse ForFailedCheck(string status, string kind, string message) =>
        new(status, "", false, 0, 0, kind, "", "", "", "", message, 0, []);
}
