namespace PSDojo.Web.Execution;

public sealed record RunnerRequest(string Mode, string Code, string ExerciseId, string ExercisePath);

public sealed record RunnerResult(
    bool Available,
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
    public static RunnerResult Unavailable(string reason) =>
        new(false, reason, "", false, 0, 0, "", "", "", "", "", "", 0, []);
}

/// <summary>
/// The web app never executes learner code itself. It hands the code to a runner through
/// this interface. Without a configured runner the app still starts and works.
/// </summary>
public interface IRunnerClient
{
    bool IsConfigured { get; }

    Task<RunnerResult> ExecuteAsync(RunnerRequest request, CancellationToken cancellationToken);
}

public sealed class UnconfiguredRunnerClient : IRunnerClient
{
    public bool IsConfigured => false;

    public Task<RunnerResult> ExecuteAsync(RunnerRequest request, CancellationToken cancellationToken) =>
        Task.FromResult(RunnerResult.Unavailable("runner_not_configured"));
}
