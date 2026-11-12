using System.Security.Cryptography;
using System.Text;
using Microsoft.Extensions.Options;
using PSDojo.Runner;

var builder = WebApplication.CreateBuilder(args);
builder.Services.Configure<RunnerSettings>(builder.Configuration.GetSection("Runner"));
builder.Services.AddSingleton<ContainerRunner>();

var app = builder.Build();

app.MapGet("/health", () => Results.Json(new { status = "ok" }));

app.MapPost("/run", async (RunRequest request, HttpContext context, ContainerRunner runner, IOptions<RunnerSettings> options, CancellationToken cancellationToken) =>
{
    var settings = options.Value;
    if (!RunnerAccess.IsAuthorized(context.Request.Headers["X-Runner-Secret"].ToString(), settings.SharedSecret))
    {
        return Results.Json(new { error = "unauthorized" }, statusCode: StatusCodes.Status401Unauthorized);
    }
    var mode = request.Mode ?? "";
    var code = request.Code ?? "";
    var id = request.ExerciseId ?? "";
    if (mode is not ("run" or "check") || code.Length == 0 || Encoding.UTF8.GetByteCount(code) > settings.MaxCodeBytes || !ContainerRunner.IsValidExerciseId(id))
    {
        return Results.Json(new { error = "invalid_request" }, statusCode: StatusCodes.Status400BadRequest);
    }
    var exercise = runner.FindExercise(id);
    if (exercise is null || exercise.Status != "approved")
    {
        return Results.Json(new { error = "not_found" }, statusCode: StatusCodes.Status404NotFound);
    }
    var result = await runner.ExecuteAsync(mode, code, exercise, cancellationToken);
    return result is null
        ? Results.Json(new { error = "busy" }, statusCode: StatusCodes.Status503ServiceUnavailable)
        : Results.Json(result);
});

await app.RunAsync();

namespace PSDojo.Runner
{
    public static class RunnerAccess
    {
        public static bool IsAuthorized(string header, string secret)
        {
            if (string.IsNullOrEmpty(secret) || string.IsNullOrEmpty(header))
            {
                return false;
            }
            var expected = Encoding.UTF8.GetBytes(Convert.ToBase64String(Encoding.UTF8.GetBytes(secret)));
            var given = Encoding.UTF8.GetBytes(header);
            return CryptographicOperations.FixedTimeEquals(expected, given);
        }
    }

    public sealed class RunnerEntryPoint;
}
