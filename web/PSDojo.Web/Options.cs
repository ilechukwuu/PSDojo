namespace PSDojo.Web;

public sealed class ContentOptions
{
    public string Path { get; set; } = "../../content";
}

public sealed class DatabaseOptions
{
    public string Provider { get; set; } = "Sqlite";
    public string ConnectionString { get; set; } = "Data Source=App_Data/psdojo.db";
}

public sealed class AuthOptions
{
    public string Provider { get; set; } = "Name";
    public List<string> Admins { get; set; } = [];
    public EntraIdOptions EntraId { get; set; } = new();
}

public sealed class EntraIdOptions
{
    public string TenantId { get; set; } = "";
    public string ClientId { get; set; } = "";
    public string ClientSecret { get; set; } = "";
    public string CallbackPath { get; set; } = "/signin-oidc";
    public string RoleClaim { get; set; } = "roles";
}

public sealed class BrowserExecutionOptions
{
    public string Mode { get; set; } = "Off";
    public bool Locked { get; set; }
    public List<string> AllowList { get; set; } = [];
}

public sealed class ReviewOptions
{
    public bool AllowSameReviewer { get; set; }
}

public sealed class RunnerOptions
{
    public string Url { get; set; } = "";
    public string SharedSecret { get; set; } = "";
    public int TimeoutSeconds { get; set; } = 30;
    public int RunsPerMinute { get; set; } = 10;
}
