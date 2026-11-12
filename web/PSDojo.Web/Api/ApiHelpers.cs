using System.Security.Claims;
using PSDojo.Web.Data;

namespace PSDojo.Web.Api;

public static class ApiHelpers
{
    public static IResult Error(int status, string code) => Results.Json(new { error = code }, statusCode: status);

    public static async Task<UserRecord?> CurrentUserAsync(this HttpContext context, IDojoStore store)
    {
        var name = context.User.Identity?.IsAuthenticated == true ? context.User.Identity.Name : null;
        return name is null ? null : await store.GetUserByNameAsync(name);
    }

    public static string RoleOf(ClaimsPrincipal principal) => principal.FindFirst(ClaimTypes.Role)?.Value ?? "";
}
