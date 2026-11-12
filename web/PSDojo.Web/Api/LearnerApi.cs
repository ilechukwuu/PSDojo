using System.Text.Json;
using PSDojo.Web.Content;
using PSDojo.Web.Data;
using PSDojo.Web.Execution;
using PSDojo.Web.Services;

namespace PSDojo.Web.Api;

public sealed record QuizSubmission(Dictionary<string, string>? Answers);

public sealed record CodeSubmission(string? Code);

public static class LearnerApi
{
    private const int MaxCodeLength = 100_000;

    public static void MapLearnerApi(this WebApplication app)
    {
        var group = app.MapGroup("/api").RequireAuthorization();

        group.MapGet("/modules", async (HttpContext context, IDojoStore store, ContentStore content, ProgressService progress) =>
        {
            var user = (await context.CurrentUserAsync(store))!;
            var states = await progress.GetStatesAsync(user.Id);
            var modules = content.Snapshot.Modules
                .Select(module => new { module, own = states.Where(state => state.Exercise.Module == module.Id).ToList() })
                .Where(item => item.own.Count > 0)
                .Select(item =>
                {
                    var complete = item.own.All(state => state.State == "completed");
                    return new
                    {
                        id = item.module.Id,
                        part = item.module.Part,
                        order = item.module.Order,
                        title = item.module.Title,
                        kind = item.module.Kind,
                        track = item.module.Track,
                        total = item.own.Count,
                        completed = item.own.Count(state => state.State == "completed"),
                        productionNote = complete ? content.ProductionNote(item.module) : null,
                        exercises = item.own.Select(state => new
                        {
                            id = state.Exercise.Id,
                            title = state.Exercise.Title,
                            type = state.Exercise.Type,
                            state = state.State,
                            missing = state.Missing,
                            localOnly = state.Exercise.LocalOnly,
                            placeholder = state.Exercise.Placeholder,
                        }),
                    };
                });
            return Results.Json(new
            {
                total = states.Count,
                completed = states.Count(state => state.State == "completed"),
                modules,
            });
        });

        group.MapGet("/exercises/{id}", async (string id, HttpContext context, IDojoStore store, ContentStore content, ProgressService progress) =>
        {
            var user = (await context.CurrentUserAsync(store))!;
            var state = await progress.GetStateAsync(user.Id, id);
            if (state is null)
            {
                return ApiHelpers.Error(StatusCodes.Status404NotFound, "not_found");
            }
            if (state.State == "locked")
            {
                return Results.Json(new { error = "locked", missing = state.Missing }, statusCode: StatusCodes.Status423Locked);
            }
            var exercise = state.Exercise;
            var states = await progress.GetStatesAsync(user.Id);
            var next = states.SkipWhile(item => item.Exercise.Id != id).Skip(1).FirstOrDefault(item => item.State != "locked");
            return Results.Json(new
            {
                id = exercise.Id,
                module = exercise.Module,
                title = exercise.Title,
                type = exercise.Type,
                concept = exercise.Concept,
                passMark = exercise.PassMark,
                localOnly = exercise.LocalOnly,
                placeholder = exercise.Placeholder,
                state = state.State,
                lesson = content.RenderPair(exercise, "lesson"),
                task = content.RenderPair(exercise, "task"),
                starter = content.ReadFile(exercise, "starter.ps1"),
                hintsUsed = state.Record.Hints,
                attempts = state.Record.Attempts,
                solutionViewed = state.Record.SolutionViewed,
                next = next?.Exercise.Id,
                questions = exercise.Type == "quiz"
                    ? content.Quiz(exercise).Select(question => new
                    {
                        id = question.Id,
                        text = question.Text,
                        options = new { de = question.OptionsDe, en = question.OptionsEn },
                    })
                    : null,
            });
        });

        group.MapPost("/exercises/{id}/hint", async (string id, HttpContext context, IDojoStore store, ProgressService progress) =>
        {
            var (state, error) = await OpenStateAsync(id, context, store, progress);
            if (state is null)
            {
                return error!;
            }
            var user = (await context.CurrentUserAsync(store))!;
            var (level, de, en) = await progress.NextHintAsync(user.Id, state);
            return Results.Json(new { level, levels = ProgressService.HintLevels, text = new LocalText(de, en), solutionUnlocked = level >= ProgressService.HintLevels });
        });

        group.MapPost("/exercises/{id}/solution", async (string id, HttpContext context, IDojoStore store, ProgressService progress) =>
        {
            var (state, error) = await OpenStateAsync(id, context, store, progress);
            if (state is null)
            {
                return error!;
            }
            if (state.Exercise.Type == "quiz")
            {
                return ApiHelpers.Error(StatusCodes.Status403Forbidden, "no_solution_for_quiz");
            }
            var user = (await context.CurrentUserAsync(store))!;
            var solution = await progress.ViewSolutionAsync(user.Id, state);
            return solution is null
                ? Results.Json(new { error = "solution_locked", hintsUsed = state.Record.Hints }, statusCode: StatusCodes.Status403Forbidden)
                : Results.Json(new { solution, recorded = true });
        });

        group.MapPost("/exercises/{id}/quiz", async (string id, QuizSubmission submission, HttpContext context, IDojoStore store, ProgressService progress) =>
        {
            var (state, error) = await OpenStateAsync(id, context, store, progress);
            if (state is null)
            {
                return error!;
            }
            if (state.Exercise.Type != "quiz")
            {
                return ApiHelpers.Error(StatusCodes.Status400BadRequest, "not_a_quiz");
            }
            var user = (await context.CurrentUserAsync(store))!;
            var result = await progress.GradeQuizAsync(user.Id, state, submission.Answers ?? []);
            return Results.Json(new
            {
                passed = result.Passed,
                total = result.Total,
                correct = result.Correct,
                score = result.Score,
                passMark = result.PassMark,
                wrong = result.Wrong,
            });
        });

        group.MapPost("/exercises/{id}/run", (string id, CodeSubmission submission, HttpContext context, IDojoStore store, ProgressService progress, ExecutionPolicy policy, IRunnerClient runner, RunLimiter limiter, CancellationToken cancellationToken) =>
            ExecuteAsync("run", id, submission, context, store, progress, policy, runner, limiter, cancellationToken));

        group.MapPost("/exercises/{id}/check", (string id, CodeSubmission submission, HttpContext context, IDojoStore store, ProgressService progress, ExecutionPolicy policy, IRunnerClient runner, RunLimiter limiter, CancellationToken cancellationToken) =>
            ExecuteAsync("check", id, submission, context, store, progress, policy, runner, limiter, cancellationToken));

        group.MapPost("/progress/import", async (JsonElement report, HttpContext context, IDojoStore store, ProgressService progress) =>
        {
            var user = (await context.CurrentUserAsync(store))!;
            var result = await progress.ImportReportAsync(user.Id, report);
            if (!result.Accepted)
            {
                return ApiHelpers.Error(StatusCodes.Status400BadRequest, result.Error);
            }
            await store.AddAuditAsync(user.Name, "Progress.Imported", $"matched {result.Matched}, newly completed {result.NewlyCompleted}, ignored {result.Ignored}");
            return Results.Json(new { matched = result.Matched, newlyCompleted = result.NewlyCompleted, ignored = result.Ignored });
        });
    }

    private static async Task<(ExerciseState? State, IResult? Error)> OpenStateAsync(string id, HttpContext context, IDojoStore store, ProgressService progress)
    {
        var user = (await context.CurrentUserAsync(store))!;
        var state = await progress.GetStateAsync(user.Id, id);
        if (state is null)
        {
            return (null, ApiHelpers.Error(StatusCodes.Status404NotFound, "not_found"));
        }
        if (state.State == "locked")
        {
            return (null, Results.Json(new { error = "locked", missing = state.Missing }, statusCode: StatusCodes.Status423Locked));
        }
        return (state, null);
    }

    private static async Task<IResult> ExecuteAsync(
        string mode,
        string id,
        CodeSubmission submission,
        HttpContext context,
        IDojoStore store,
        ProgressService progress,
        ExecutionPolicy policy,
        IRunnerClient runner,
        RunLimiter limiter,
        CancellationToken cancellationToken)
    {
        var user = (await context.CurrentUserAsync(store))!;
        if (!await policy.IsAllowedAsync(user.Name))
        {
            return ApiHelpers.Error(StatusCodes.Status403Forbidden, "execution_disabled");
        }
        var (state, error) = await OpenStateAsync(id, context, store, progress);
        if (state is null)
        {
            return error!;
        }
        if (state.Exercise.Type == "quiz" || state.Exercise.LocalOnly)
        {
            return ApiHelpers.Error(StatusCodes.Status400BadRequest, "not_executable_in_browser");
        }
        var code = submission.Code ?? "";
        if (code.Length == 0 || code.Length > MaxCodeLength)
        {
            return ApiHelpers.Error(StatusCodes.Status400BadRequest, "invalid_code");
        }
        if (!runner.IsConfigured)
        {
            return ApiHelpers.Error(StatusCodes.Status503ServiceUnavailable, "runner_not_configured");
        }
        if (!limiter.TryAcquire(user.Name, out var retryAfter))
        {
            context.Response.Headers.RetryAfter = retryAfter.ToString(System.Globalization.CultureInfo.InvariantCulture);
            return Results.Json(new { error = "rate_limited", retryAfter }, statusCode: StatusCodes.Status429TooManyRequests);
        }

        var result = await runner.ExecuteAsync(new RunnerRequest(mode, code, state.Exercise.Id, state.Exercise.Path), cancellationToken);
        if (!result.Available)
        {
            return ApiHelpers.Error(StatusCodes.Status503ServiceUnavailable, result.Status);
        }
        if (mode == "check")
        {
            await progress.RecordCheckAsync(user.Id, state, result.Passed);
        }
        return Results.Json(new
        {
            mode,
            status = result.Status,
            output = result.Output,
            passed = result.Passed,
            total = result.Total,
            passedCount = result.PassedCount,
            kind = result.Kind,
            testName = result.TestName,
            expected = result.Expected,
            actual = result.Actual,
            because = result.Because,
            message = result.Message,
            line = result.Line,
            failedTests = result.FailedTests,
            concept = state.Exercise.Concept,
        });
    }
}
