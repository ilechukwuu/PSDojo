namespace PSDojo.Web.Auth;

public static class Roles
{
    public const string Learner = "learner";
    public const string Reviewer = "reviewer";
    public const string Trainer = "trainer";
    public const string Admin = "admin";

    public static readonly string[] All = [Learner, Reviewer, Trainer, Admin];

    public static bool IsValid(string role) => All.Contains(role);
}

public static class Policies
{
    public const string Reviewer = "Reviewer";
    public const string Trainer = "Trainer";
    public const string Admin = "Admin";
}
