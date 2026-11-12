using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using PSDojo.Web.Auth;
using PSDojo.Web.Data;
using PSDojo.Web.Execution;

namespace PSDojo.Web.Api;

public sealed record LoginRequest(string? Name);

public static class AccountApi
{
    public static void MapAccountApi(this WebApplication app)
    {
        app.MapGet("/api/me", async (HttpContext context, IDojoStore store, ILoginProvider provider, ExecutionPolicy policy, IRunnerClient runner) =>
        {
            var user = await context.CurrentUserAsync(store);
            var state = await policy.GetStateAsync();
            return Results.Json(new
            {
                authenticated = user is not null,
                name = user?.Name ?? "",
                role = user?.Role ?? "",
                provider = provider.Name,
                nameLogin = provider.SupportsNameLogin,
                execution = new
                {
                    mode = state.Mode.ToString(),
                    enabledForMe = user is not null && await policy.IsAllowedAsync(user.Name),
                    runnerConfigured = runner.IsConfigured,
                },
            });
        });

        app.MapPost("/api/login", async (LoginRequest request, HttpContext context, UserSessions sessions, ILoginProvider provider) =>
        {
            if (!provider.SupportsNameLogin)
            {
                return ApiHelpers.Error(StatusCodes.Status400BadRequest, "name_login_disabled");
            }
            var name = (request.Name ?? "").Trim();
            if (!UserSessions.IsValidName(name))
            {
                return ApiHelpers.Error(StatusCodes.Status400BadRequest, "invalid_name");
            }
            var user = await sessions.RegisterAsync(name, null);
            await context.SignInAsync(CookieAuthenticationDefaults.AuthenticationScheme, UserSessions.CreatePrincipal(user));
            return Results.Json(new { name = user.Name, role = user.Role });
        });

        app.MapGet("/signin", (HttpContext context, ILoginProvider provider) =>
            provider.ChallengeScheme is null
                ? Results.Redirect("/")
                : Results.Challenge(new AuthenticationProperties { RedirectUri = "/" }, [provider.ChallengeScheme]));

        app.MapPost("/api/logout", async (HttpContext context) =>
        {
            await context.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);
            return Results.Json(new { ok = true });
        });
    }
}
