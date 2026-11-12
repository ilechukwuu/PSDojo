using System.Net.Http.Json;
using System.Text;
using Microsoft.Extensions.Options;

namespace PSDojo.Web.Execution;

public sealed record RunnerWireRequest(string Mode, string Code, string ExerciseId);

public sealed record RunnerWireResponse(
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
    List<string>? FailedTests);

/// <summary>
/// Sends learner code to the separate runner service. The code travels as a JSON string in
/// the request body and never becomes part of a command line in this process.
/// </summary>
public sealed class HttpRunnerClient(HttpClient client, IOptions<RunnerOptions> options, ILogger<HttpRunnerClient> logger) : IRunnerClient
{
    public bool IsConfigured => true;

    public async Task<RunnerResult> ExecuteAsync(RunnerRequest request, CancellationToken cancellationToken)
    {
        try
        {
            using var message = new HttpRequestMessage(HttpMethod.Post, "run")
            {
                Content = JsonContent.Create(new RunnerWireRequest(request.Mode, request.Code, request.ExerciseId)),
            };
            message.Headers.Add("X-Runner-Secret", Convert.ToBase64String(Encoding.UTF8.GetBytes(options.Value.SharedSecret)));
            using var response = await client.SendAsync(message, cancellationToken);
            if (!response.IsSuccessStatusCode)
            {
                logger.LogWarning("Runner answered {Status}", (int)response.StatusCode);
                return RunnerResult.Unavailable("runner_error");
            }
            var body = await response.Content.ReadFromJsonAsync<RunnerWireResponse>(cancellationToken);
            if (body is null)
            {
                return RunnerResult.Unavailable("runner_error");
            }
            return new RunnerResult(
                true,
                body.Status,
                body.Output ?? "",
                body.Passed,
                body.Total,
                body.PassedCount,
                body.Kind ?? "",
                body.TestName ?? "",
                body.Expected ?? "",
                body.Actual ?? "",
                body.Because ?? "",
                body.Message ?? "",
                body.Line,
                body.FailedTests ?? []);
        }
        catch (Exception exception) when (exception is HttpRequestException or TaskCanceledException or System.Text.Json.JsonException)
        {
            logger.LogWarning(exception, "Runner is not reachable");
            return RunnerResult.Unavailable("runner_unreachable");
        }
    }
}
