using Microsoft.Extensions.Options;
using PSDojo.Web.Auth;
using PSDojo.Web.Content;
using PSDojo.Web.Data;

namespace PSDojo.Web.Api;

public sealed record ReviewDecision(string? Comment);

public static class ReviewApi
{
    public static void MapReviewApi(this WebApplication app)
    {
        var group = app.MapGroup("/api/review").RequireAuthorization(Policies.Reviewer);

        group.MapGet("/items", (string? status, ContentStore content) =>
        {
            var wanted = string.IsNullOrWhiteSpace(status) ? ["draft", "reviewed"] : status.Split(',', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries);
            var items = content.Snapshot.Exercises
                .Where(exercise => wanted.Contains(exercise.Status))
                .Select(exercise => new
                {
                    id = exercise.Id,
                    module = exercise.Module,
                    title = exercise.Title,
                    type = exercise.Type,
                    status = exercise.Status,
                    placeholder = exercise.Placeholder,
                    review = exercise.Review,
                });
            return Results.Json(new { items });
        });

        group.MapGet("/items/{id}", (string id, ContentStore content) =>
        {
            var exercise = content.FindAny(id);
            if (exercise is null)
            {
                return ApiHelpers.Error(StatusCodes.Status404NotFound, "not_found");
            }
            var (hintsDe, hintsEn) = content.Hints(exercise);
            return Results.Json(new
            {
                id = exercise.Id,
                module = exercise.Module,
                title = exercise.Title,
                concept = exercise.Concept,
                type = exercise.Type,
                order = exercise.Order,
                status = exercise.Status,
                passMark = exercise.PassMark,
                prerequisites = exercise.Prerequisites,
                minPowerShell = exercise.MinPowerShell,
                requires = exercise.Requires,
                placeholder = exercise.Placeholder,
                lesson = content.RenderPair(exercise, "lesson"),
                task = content.RenderPair(exercise, "task"),
                hints = new { de = hintsDe, en = hintsEn },
                starter = content.ReadFile(exercise, "starter.ps1"),
                solution = content.ReadFile(exercise, "solution.ps1"),
                wrong = content.ReadFile(exercise, "wrong.ps1"),
                tests = content.ReadFile(exercise, "tests.ps1"),
                questions = exercise.Type == "quiz"
                    ? content.Quiz(exercise).Select(question => new
                    {
                        id = question.Id,
                        text = question.Text,
                        options = new { de = question.OptionsDe, en = question.OptionsEn },
                        answer = question.Answer,
                    })
                    : null,
                history = exercise.History,
            });
        });

        group.MapPost("/items/{id}/approve", async (string id, ReviewDecision decision, HttpContext context, ContentStore content, IDojoStore store, IOptions<ReviewOptions> options) =>
        {
            var exercise = content.FindAny(id);
            if (exercise is null)
            {
                return ApiHelpers.Error(StatusCodes.Status404NotFound, "not_found");
            }
            if (exercise.Status == "approved")
            {
                return ApiHelpers.Error(StatusCodes.Status409Conflict, "already_approved");
            }
            var reviewer = context.User.Identity!.Name!;
            var next = exercise.Status == "reviewed" ? "approved" : "reviewed";
            if (next == "approved" && exercise.Review?.Reviewer == reviewer && !options.Value.AllowSameReviewer)
            {
                return ApiHelpers.Error(StatusCodes.Status409Conflict, "same_reviewer");
            }
            var entry = content.ApplyReview(exercise, "approve", next, reviewer, (decision.Comment ?? "").Trim());
            await store.AddAuditAsync(reviewer, "Review.Approved", $"{id}: {entry.From} -> {entry.To}");
            return Results.Json(new { id, status = next, review = entry });
        });

        group.MapPost("/items/{id}/reject", async (string id, ReviewDecision decision, HttpContext context, ContentStore content, IDojoStore store) =>
        {
            var exercise = content.FindAny(id);
            if (exercise is null)
            {
                return ApiHelpers.Error(StatusCodes.Status404NotFound, "not_found");
            }
            var comment = (decision.Comment ?? "").Trim();
            if (comment.Length == 0)
            {
                return ApiHelpers.Error(StatusCodes.Status400BadRequest, "comment_required");
            }
            var reviewer = context.User.Identity!.Name!;
            var entry = content.ApplyReview(exercise, "reject", "draft", reviewer, comment);
            await store.AddAuditAsync(reviewer, "Review.Rejected", $"{id}: {entry.From} -> {entry.To}");
            return Results.Json(new { id, status = "draft", review = entry });
        });
    }
}
