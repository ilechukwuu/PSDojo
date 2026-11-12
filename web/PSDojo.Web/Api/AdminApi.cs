using PSDojo.Web.Auth;
using PSDojo.Web.Data;
using PSDojo.Web.Execution;

namespace PSDojo.Web.Api;

public sealed record ExecutionRequest(string? Mode, List<string>? AllowList);

public sealed record RoleRequest(string? Role);

public static class AdminApi
{
    public static void MapAdminApi(this WebApplication app)
    {
        var group = app.MapGroup("/api/admin").RequireAuthorization(Policies.Admin);

        group.MapGet("/execution", async (ExecutionPolicy policy, IRunnerClient runner) =>
        {
            var state = await policy.GetStateAsync();
            return Results.Json(new { mode = state.Mode.ToString(), locked = state.Locked, allowList = state.AllowList, runnerConfigured = runner.IsConfigured });
        });

        group.MapPost("/execution", async (ExecutionRequest request, HttpContext context, ExecutionPolicy policy) =>
        {
            var change = await policy.SetAsync(request.Mode ?? "", request.AllowList ?? [], context.User.Identity!.Name!);
            if (!change.Changed)
            {
                var status = change.Error == "locked" ? StatusCodes.Status409Conflict : StatusCodes.Status400BadRequest;
                return ApiHelpers.Error(status, change.Error!);
            }
            return Results.Json(new { mode = change.State.Mode.ToString(), locked = change.State.Locked, allowList = change.State.AllowList });
        });

        group.MapGet("/audit", async (IDojoStore store) => Results.Json(new { entries = await store.GetAuditAsync(200) }));

        group.MapGet("/users", async (IDojoStore store) => Results.Json(new { users = await store.GetUsersAsync() }));

        group.MapPost("/users/{name}/role", async (string name, RoleRequest request, HttpContext context, IDojoStore store) =>
        {
            var role = request.Role ?? "";
            if (!Roles.IsValid(role))
            {
                return ApiHelpers.Error(StatusCodes.Status400BadRequest, "invalid_role");
            }
            var user = await store.GetUserByNameAsync(UserSessions.Normalize(name));
            if (user is null)
            {
                return ApiHelpers.Error(StatusCodes.Status404NotFound, "not_found");
            }
            var actor = context.User.Identity!.Name!;
            if (user.Name == actor && role != Roles.Admin)
            {
                return ApiHelpers.Error(StatusCodes.Status409Conflict, "cannot_demote_yourself");
            }
            await store.SetUserRoleAsync(user.Name, role);
            await store.AddAuditAsync(actor, "User.RoleChanged", $"{user.Name}: {user.Role} -> {role}");
            return Results.Json(new { name = user.Name, role });
        });
    }
}
