using PSDojo.Web.Auth;
using PSDojo.Web.Content;
using PSDojo.Web.Data;
using PSDojo.Web.Services;

namespace PSDojo.Web.Api;

public static class TrainerApi
{
    public static void MapTrainerApi(this WebApplication app)
    {
        app.MapGet("/api/trainer/overview", async (ContentStore content, IDojoStore store) =>
        {
            var approved = content.Approved;
            var approvedIds = approved.Select(exercise => exercise.Id).ToHashSet();
            var users = await store.GetUsersAsync();
            var all = (await store.GetAllProgressAsync()).Where(item => approvedIds.Contains(item.Record.ExerciseId)).ToList();
            var byUser = all.GroupBy(item => item.UserId).ToDictionary(group => group.Key, group => group.Select(item => item.Record).ToList());
            var modules = content.Snapshot.Modules.Where(module => approved.Any(exercise => exercise.Module == module.Id)).ToList();

            var learners = users
                .Where(user => user.Role == Roles.Learner || byUser.ContainsKey(user.Id))
                .Select(user =>
                {
                    var records = byUser.GetValueOrDefault(user.Id) ?? [];
                    var done = records.Where(record => record.IsCompleted).Select(record => record.ExerciseId).ToHashSet();
                    return new
                    {
                        name = user.Name,
                        role = user.Role,
                        completed = done.Count,
                        total = approved.Count,
                        percent = approved.Count == 0 ? 0 : (int)Math.Round(100.0 * done.Count / approved.Count, MidpointRounding.AwayFromZero),
                        attempts = records.Sum(record => record.Attempts),
                        hints = records.Sum(record => record.Hints),
                        solutionsViewed = records.Count(record => record.SolutionViewed),
                        imported = records.Count(record => record.IsCompleted && record.Source == "import"),
                        minutes = records.Sum(record => record.Seconds) / 60,
                        lastActivity = records.Select(record => record.UpdatedAt).DefaultIfEmpty("").Max(),
                        modules = modules.Select(module =>
                        {
                            var own = approved.Where(exercise => exercise.Module == module.Id).ToList();
                            return new { id = module.Id, completed = own.Count(exercise => done.Contains(exercise.Id)), total = own.Count };
                        }),
                    };
                })
                .ToList();

            var hardest = approved
                .Select(exercise =>
                {
                    var records = all.Where(item => item.Record.ExerciseId == exercise.Id).Select(item => item.Record)
                        .Where(record => record.Attempts > 0 || record.IsCompleted)
                        .ToList();
                    var open = records.Count(record => !record.IsCompleted);
                    return new
                    {
                        id = exercise.Id,
                        title = exercise.Title,
                        type = exercise.Type,
                        learners = records.Count,
                        notCompleted = open,
                        failRate = records.Count == 0 ? 0 : (int)Math.Round(100.0 * open / records.Count, MidpointRounding.AwayFromZero),
                        averageAttempts = records.Count == 0 ? 0 : Math.Round(records.Average(record => (double)record.Attempts), 1),
                        hints = records.Sum(record => record.Hints),
                        solutionsViewed = records.Count(record => record.SolutionViewed),
                    };
                })
                .Where(item => item.learners > 0)
                .OrderByDescending(item => item.failRate)
                .ThenByDescending(item => item.averageAttempts)
                .ThenBy(item => item.id, StringComparer.Ordinal)
                .Take(15);

            return Results.Json(new
            {
                modules = modules.Select(module => new { id = module.Id, title = module.Title }),
                learners,
                hardest,
            });
        }).RequireAuthorization(Policies.Trainer);
    }
}
