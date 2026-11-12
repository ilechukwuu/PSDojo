namespace PSDojo.Web.Data;

public sealed record UserRecord(long Id, string Name, string Role, string CreatedAt, string LastSeenAt);

public sealed record ProgressRecord(
    string ExerciseId,
    string Status,
    int Attempts,
    int Hints,
    bool SolutionViewed,
    int Seconds,
    string CompletedAt,
    string UpdatedAt,
    string Source)
{
    public static ProgressRecord Empty(string exerciseId) => new(exerciseId, "open", 0, 0, false, 0, "", "", "web");

    public bool IsCompleted => Status == "completed";
}

public sealed record UserProgress(long UserId, ProgressRecord Record);

public sealed record AuditRecord(long Id, string Timestamp, string User, string Action, string Detail);

/// <summary>
/// All persistence of the web app. SQLite implements it today. A SQL Server implementation
/// replaces it by registering another class for this interface in Program.cs.
/// </summary>
public interface IDojoStore
{
    Task InitializeAsync();

    Task<UserRecord> UpsertUserAsync(string name, string roleIfNew);

    Task<UserRecord?> GetUserByNameAsync(string name);

    Task<IReadOnlyList<UserRecord>> GetUsersAsync();

    Task SetUserRoleAsync(string name, string role);

    Task<IReadOnlyList<ProgressRecord>> GetProgressAsync(long userId);

    Task<IReadOnlyList<UserProgress>> GetAllProgressAsync();

    Task SaveProgressAsync(long userId, ProgressRecord record);

    Task<string?> GetSettingAsync(string key);

    Task SetSettingAsync(string key, string value);

    Task AddAuditAsync(string user, string action, string detail);

    Task<IReadOnlyList<AuditRecord>> GetAuditAsync(int limit);
}
