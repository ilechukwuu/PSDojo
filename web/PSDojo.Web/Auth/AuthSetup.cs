using System.Security.Claims;
using System.Text.RegularExpressions;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authentication.OpenIdConnect;
using Microsoft.Extensions.Options;
using PSDojo.Web.Data;

namespace PSDojo.Web.Auth;

/// <summary>
/// The sign-in method sits behind this interface. NameLoginProvider is the simple start,
/// EntraIdLoginProvider is single sign-on. Auth:Provider in configuration selects one.
/// Both end in the same cookie session and the same user table.
/// </summary>
public interface ILoginProvider
{
    string Name { get; }

    bool SupportsNameLogin { get; }

    string? ChallengeScheme { get; }
}

public sealed class NameLoginProvider : ILoginProvider
{
    public string Name => "Name";

    public bool SupportsNameLogin => true;

    public string? ChallengeScheme => null;
}

public sealed class EntraIdLoginProvider : ILoginProvider
{
    public string Name => "EntraId";

    public bool SupportsNameLogin => false;

    public string? ChallengeScheme => OpenIdConnectDefaults.AuthenticationScheme;
}

public sealed partial class UserSessions(IDojoStore store, IOptions<AuthOptions> options)
{
    [GeneratedRegex("^[A-Za-z0-9._@-]{2,64}$")]
    private static partial Regex NamePattern();

    public static bool IsValidName(string name) => NamePattern().IsMatch(name);

    public static string Normalize(string name) => name.Trim().ToLowerInvariant();

    public async Task<UserRecord> RegisterAsync(string name, string? roleFromIdentityProvider)
    {
        var normalized = Normalize(name);
        var isConfiguredAdmin = options.Value.Admins.Any(admin => Normalize(admin) == normalized);
        var role = isConfiguredAdmin ? Roles.Admin : Roles.Learner;
        if (roleFromIdentityProvider is not null && Roles.IsValid(roleFromIdentityProvider))
        {
            role = roleFromIdentityProvider;
        }
        var user = await store.UpsertUserAsync(normalized, role);
        var wanted = isConfiguredAdmin ? Roles.Admin : roleFromIdentityProvider;
        if (wanted is not null && Roles.IsValid(wanted) && user.Role != wanted)
        {
            await store.SetUserRoleAsync(normalized, wanted);
            user = user with { Role = wanted };
        }
        return user;
    }

    public static ClaimsPrincipal CreatePrincipal(UserRecord user)
    {
        var identity = new ClaimsIdentity(
            [new Claim(ClaimTypes.Name, user.Name)],
            CookieAuthenticationDefaults.AuthenticationScheme,
            ClaimTypes.Name,
            ClaimTypes.Role);
        return new ClaimsPrincipal(identity);
    }
}

/// <summary>
/// The role is read from the database on every request, so a role change by an admin
/// takes effect at once and never depends on what the cookie says.
/// </summary>
public sealed class RoleClaimsTransformation(IDojoStore store) : IClaimsTransformation
{
    public async Task<ClaimsPrincipal> TransformAsync(ClaimsPrincipal principal)
    {
        if (principal.Identity is not ClaimsIdentity { IsAuthenticated: true } identity || identity.Name is null)
        {
            return principal;
        }
        if (identity.HasClaim(claim => claim.Type == ClaimTypes.Role))
        {
            return principal;
        }
        var user = await store.GetUserByNameAsync(identity.Name);
        if (user is null)
        {
            return principal;
        }
        var clone = identity.Clone();
        clone.AddClaim(new Claim(ClaimTypes.Role, user.Role));
        return new ClaimsPrincipal(clone);
    }
}

public static class AuthSetup
{
    public static void AddDojoAuthentication(this WebApplicationBuilder builder)
    {
        var options = builder.Configuration.GetSection("Auth").Get<AuthOptions>() ?? new AuthOptions();
        var useEntra = string.Equals(options.Provider, "EntraId", StringComparison.OrdinalIgnoreCase);
        if (!useEntra && !string.Equals(options.Provider, "Name", StringComparison.OrdinalIgnoreCase))
        {
            throw new InvalidOperationException($"Auth:Provider '{options.Provider}' is not supported. Use Name or EntraId.");
        }

        if (useEntra)
        {
            builder.Services.AddSingleton<ILoginProvider, EntraIdLoginProvider>();
        }
        else
        {
            builder.Services.AddSingleton<ILoginProvider, NameLoginProvider>();
        }
        builder.Services.AddScoped<UserSessions>();
        builder.Services.AddScoped<IClaimsTransformation, RoleClaimsTransformation>();

        var authentication = builder.Services
            .AddAuthentication(CookieAuthenticationDefaults.AuthenticationScheme)
            .AddCookie(cookie =>
            {
                cookie.Cookie.Name = "psdojo";
                cookie.Cookie.HttpOnly = true;
                cookie.Cookie.SameSite = SameSiteMode.Lax;
                cookie.Cookie.SecurePolicy = CookieSecurePolicy.SameAsRequest;
                cookie.SlidingExpiration = true;
                cookie.ExpireTimeSpan = TimeSpan.FromHours(12);
                cookie.Events.OnRedirectToLogin = context =>
                {
                    context.Response.StatusCode = StatusCodes.Status401Unauthorized;
                    return Task.CompletedTask;
                };
                cookie.Events.OnRedirectToAccessDenied = context =>
                {
                    context.Response.StatusCode = StatusCodes.Status403Forbidden;
                    return Task.CompletedTask;
                };
            });

        if (useEntra)
        {
            var entra = options.EntraId;
            if (string.IsNullOrWhiteSpace(entra.TenantId) || string.IsNullOrWhiteSpace(entra.ClientId))
            {
                throw new InvalidOperationException("Auth:Provider is EntraId but Auth:EntraId:TenantId or Auth:EntraId:ClientId is empty.");
            }
            authentication.AddOpenIdConnect(oidc =>
            {
                oidc.Authority = $"https://login.microsoftonline.com/{entra.TenantId}/v2.0";
                oidc.ClientId = entra.ClientId;
                oidc.ClientSecret = entra.ClientSecret;
                oidc.ResponseType = "code";
                oidc.CallbackPath = entra.CallbackPath;
                oidc.SignInScheme = CookieAuthenticationDefaults.AuthenticationScheme;
                oidc.SaveTokens = false;
                oidc.Scope.Clear();
                oidc.Scope.Add("openid");
                oidc.Scope.Add("profile");
                oidc.TokenValidationParameters.NameClaimType = "preferred_username";
                oidc.Events.OnTokenValidated = async context =>
                {
                    var name = context.Principal?.FindFirst("preferred_username")?.Value
                        ?? context.Principal?.FindFirst(ClaimTypes.Upn)?.Value
                        ?? context.Principal?.FindFirst(ClaimTypes.Email)?.Value;
                    if (name is null || !UserSessions.IsValidName(name.Trim()))
                    {
                        context.Fail("The sign-in did not return a usable user name.");
                        return;
                    }
                    var granted = context.Principal!.FindAll(entra.RoleClaim)
                        .Select(claim => claim.Value.ToLowerInvariant())
                        .Where(Roles.IsValid)
                        .ToList();
                    var role = new[] { Roles.Admin, Roles.Trainer, Roles.Reviewer, Roles.Learner }.FirstOrDefault(granted.Contains);
                    var sessions = context.HttpContext.RequestServices.GetRequiredService<UserSessions>();
                    var user = await sessions.RegisterAsync(name, role);
                    context.Principal = UserSessions.CreatePrincipal(user);
                };
            });
        }

        builder.Services.AddAuthorizationBuilder()
            .AddPolicy(Policies.Reviewer, policy => policy.RequireRole(Roles.Reviewer, Roles.Admin))
            .AddPolicy(Policies.Trainer, policy => policy.RequireRole(Roles.Trainer, Roles.Admin))
            .AddPolicy(Policies.Admin, policy => policy.RequireRole(Roles.Admin));
    }
}
