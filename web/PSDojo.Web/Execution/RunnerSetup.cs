namespace PSDojo.Web.Execution;

public static class RunnerSetup
{
    public static void AddRunnerClient(this IServiceCollection services, IConfiguration configuration)
    {
        var options = configuration.GetSection("Runner").Get<RunnerOptions>() ?? new RunnerOptions();
        if (string.IsNullOrWhiteSpace(options.Url))
        {
            services.AddSingleton<IRunnerClient, UnconfiguredRunnerClient>();
            return;
        }
        services.AddHttpClient<IRunnerClient, HttpRunnerClient>(client =>
        {
            client.BaseAddress = new Uri(options.Url);
            client.Timeout = TimeSpan.FromSeconds(Math.Max(5, options.TimeoutSeconds));
        });
    }
}
