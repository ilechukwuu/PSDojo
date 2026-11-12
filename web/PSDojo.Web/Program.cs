using System.Text.Json;
using PSDojo.Web;
using PSDojo.Web.Api;
using PSDojo.Web.Auth;
using PSDojo.Web.Content;
using PSDojo.Web.Data;
using PSDojo.Web.Execution;
using PSDojo.Web.Services;

var builder = WebApplication.CreateBuilder(args);

builder.Services.Configure<ContentOptions>(builder.Configuration.GetSection("Content"));
builder.Services.Configure<DatabaseOptions>(builder.Configuration.GetSection("Database"));
builder.Services.Configure<AuthOptions>(builder.Configuration.GetSection("Auth"));
builder.Services.Configure<BrowserExecutionOptions>(builder.Configuration.GetSection("BrowserExecution"));
builder.Services.Configure<ReviewOptions>(builder.Configuration.GetSection("Review"));
builder.Services.Configure<RunnerOptions>(builder.Configuration.GetSection("Runner"));
builder.Services.ConfigureHttpJsonOptions(options =>
{
    options.SerializerOptions.PropertyNamingPolicy = JsonNamingPolicy.CamelCase;
});

var database = builder.Configuration.GetSection("Database").Get<DatabaseOptions>() ?? new DatabaseOptions();
if (string.Equals(database.Provider, "Sqlite", StringComparison.OrdinalIgnoreCase))
{
    builder.Services.AddSingleton<IDojoStore, SqliteDojoStore>();
}
else
{
    throw new InvalidOperationException($"Database:Provider '{database.Provider}' is not supported. Register an IDojoStore implementation for it in Program.cs.");
}

builder.Services.AddSingleton(TimeProvider.System);
builder.Services.AddSingleton<ContentStore>();
builder.Services.AddSingleton<RunLimiter>();
builder.Services.AddScoped<ProgressService>();
builder.Services.AddScoped<ExecutionPolicy>();
builder.Services.AddRunnerClient(builder.Configuration);
builder.AddDojoAuthentication();

var app = builder.Build();

await app.Services.GetRequiredService<IDojoStore>().InitializeAsync();

app.Use(async (context, next) =>
{
    context.Response.Headers.XContentTypeOptions = "nosniff";
    context.Response.Headers.XFrameOptions = "DENY";
    context.Response.Headers["Referrer-Policy"] = "same-origin";
    var isApi = context.Request.Path.StartsWithSegments("/api");
    if (isApi)
    {
        context.Response.Headers.CacheControl = "no-store";
    }
    var changesState = !HttpMethods.IsGet(context.Request.Method) && !HttpMethods.IsHead(context.Request.Method) && !HttpMethods.IsOptions(context.Request.Method);
    if (isApi && changesState && context.Request.Headers["X-PSDojo-Request"] != "1")
    {
        context.Response.StatusCode = StatusCodes.Status400BadRequest;
        await context.Response.WriteAsJsonAsync(new { error = "missing_request_header" });
        return;
    }
    await next();
});

app.UseDefaultFiles();
app.UseStaticFiles();
app.UseAuthentication();
app.UseAuthorization();

app.MapAccountApi();
app.MapLearnerApi();
app.MapReviewApi();
app.MapTrainerApi();
app.MapAdminApi();
app.MapGet("/api/health", () => Results.Json(new { status = "ok" }));

await app.RunAsync();

public partial class Program;
