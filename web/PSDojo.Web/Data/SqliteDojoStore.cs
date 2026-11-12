using Microsoft.Data.Sqlite;
using Microsoft.Extensions.Options;

namespace PSDojo.Web.Data;

public sealed class SqliteDojoStore : IDojoStore
{
    private readonly string _connectionString;

    public SqliteDojoStore(IOptions<DatabaseOptions> options, IWebHostEnvironment environment)
    {
        var builder = new SqliteConnectionStringBuilder(options.Value.ConnectionString);
        if (builder.Mode != SqliteOpenMode.Memory && !Path.IsPathRooted(builder.DataSource) && !builder.DataSource.StartsWith(':'))
        {
            builder.DataSource = Path.GetFullPath(Path.Combine(environment.ContentRootPath, builder.DataSource));
        }
        if (builder.Mode != SqliteOpenMode.Memory && Path.IsPathRooted(builder.DataSource))
        {
            Directory.CreateDirectory(Path.GetDirectoryName(builder.DataSource)!);
        }
        _connectionString = builder.ToString();
    }

    public async Task InitializeAsync()
    {
        await using var connection = await OpenAsync();
        var command = connection.CreateCommand();
        command.CommandText = """
            CREATE TABLE IF NOT EXISTS users (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL UNIQUE,
                role TEXT NOT NULL,
                created_at TEXT NOT NULL,
                last_seen_at TEXT NOT NULL
            );
            CREATE TABLE IF NOT EXISTS progress (
                user_id INTEGER NOT NULL,
                exercise_id TEXT NOT NULL,
                status TEXT NOT NULL,
                attempts INTEGER NOT NULL,
                hints INTEGER NOT NULL,
                solution_viewed INTEGER NOT NULL,
                seconds INTEGER NOT NULL,
                completed_at TEXT NOT NULL,
                updated_at TEXT NOT NULL,
                source TEXT NOT NULL,
                PRIMARY KEY (user_id, exercise_id)
            );
            CREATE TABLE IF NOT EXISTS settings (
                key TEXT PRIMARY KEY,
                value TEXT NOT NULL
            );
            CREATE TABLE IF NOT EXISTS audit (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                timestamp TEXT NOT NULL,
                user TEXT NOT NULL,
                action TEXT NOT NULL,
                detail TEXT NOT NULL
            );
            """;
        await command.ExecuteNonQueryAsync();
    }

    public async Task<UserRecord> UpsertUserAsync(string name, string roleIfNew)
    {
        var now = DateTime.UtcNow.ToString("o");
        await using var connection = await OpenAsync();
        var command = connection.CreateCommand();
        command.CommandText = """
            INSERT INTO users (name, role, created_at, last_seen_at) VALUES ($name, $role, $now, $now)
            ON CONFLICT(name) DO UPDATE SET last_seen_at = $now;
            """;
        command.Parameters.AddWithValue("$name", name);
        command.Parameters.AddWithValue("$role", roleIfNew);
        command.Parameters.AddWithValue("$now", now);
        await command.ExecuteNonQueryAsync();
        return (await GetUserByNameAsync(name))!;
    }

    public async Task<UserRecord?> GetUserByNameAsync(string name)
    {
        await using var connection = await OpenAsync();
        var command = connection.CreateCommand();
        command.CommandText = "SELECT id, name, role, created_at, last_seen_at FROM users WHERE name = $name";
        command.Parameters.AddWithValue("$name", name);
        await using var reader = await command.ExecuteReaderAsync();
        return await reader.ReadAsync() ? ReadUser(reader) : null;
    }

    public async Task<IReadOnlyList<UserRecord>> GetUsersAsync()
    {
        await using var connection = await OpenAsync();
        var command = connection.CreateCommand();
        command.CommandText = "SELECT id, name, role, created_at, last_seen_at FROM users ORDER BY name";
        var users = new List<UserRecord>();
        await using var reader = await command.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            users.Add(ReadUser(reader));
        }
        return users;
    }

    public async Task SetUserRoleAsync(string name, string role)
    {
        await using var connection = await OpenAsync();
        var command = connection.CreateCommand();
        command.CommandText = "UPDATE users SET role = $role WHERE name = $name";
        command.Parameters.AddWithValue("$name", name);
        command.Parameters.AddWithValue("$role", role);
        await command.ExecuteNonQueryAsync();
    }

    public async Task<IReadOnlyList<ProgressRecord>> GetProgressAsync(long userId)
    {
        await using var connection = await OpenAsync();
        var command = connection.CreateCommand();
        command.CommandText = """
            SELECT user_id, exercise_id, status, attempts, hints, solution_viewed, seconds, completed_at, updated_at, source
            FROM progress WHERE user_id = $user
            """;
        command.Parameters.AddWithValue("$user", userId);
        var records = new List<ProgressRecord>();
        await using var reader = await command.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            records.Add(ReadProgress(reader).Record);
        }
        return records;
    }

    public async Task<IReadOnlyList<UserProgress>> GetAllProgressAsync()
    {
        await using var connection = await OpenAsync();
        var command = connection.CreateCommand();
        command.CommandText = """
            SELECT user_id, exercise_id, status, attempts, hints, solution_viewed, seconds, completed_at, updated_at, source
            FROM progress
            """;
        var records = new List<UserProgress>();
        await using var reader = await command.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            records.Add(ReadProgress(reader));
        }
        return records;
    }

    public async Task SaveProgressAsync(long userId, ProgressRecord record)
    {
        await using var connection = await OpenAsync();
        var command = connection.CreateCommand();
        command.CommandText = """
            INSERT INTO progress (user_id, exercise_id, status, attempts, hints, solution_viewed, seconds, completed_at, updated_at, source)
            VALUES ($user, $exercise, $status, $attempts, $hints, $solution, $seconds, $completed, $updated, $source)
            ON CONFLICT(user_id, exercise_id) DO UPDATE SET
                status = $status, attempts = $attempts, hints = $hints, solution_viewed = $solution,
                seconds = $seconds, completed_at = $completed, updated_at = $updated, source = $source;
            """;
        command.Parameters.AddWithValue("$user", userId);
        command.Parameters.AddWithValue("$exercise", record.ExerciseId);
        command.Parameters.AddWithValue("$status", record.Status);
        command.Parameters.AddWithValue("$attempts", record.Attempts);
        command.Parameters.AddWithValue("$hints", record.Hints);
        command.Parameters.AddWithValue("$solution", record.SolutionViewed ? 1 : 0);
        command.Parameters.AddWithValue("$seconds", record.Seconds);
        command.Parameters.AddWithValue("$completed", record.CompletedAt);
        command.Parameters.AddWithValue("$updated", DateTime.UtcNow.ToString("o"));
        command.Parameters.AddWithValue("$source", record.Source);
        await command.ExecuteNonQueryAsync();
    }

    public async Task<string?> GetSettingAsync(string key)
    {
        await using var connection = await OpenAsync();
        var command = connection.CreateCommand();
        command.CommandText = "SELECT value FROM settings WHERE key = $key";
        command.Parameters.AddWithValue("$key", key);
        return await command.ExecuteScalarAsync() as string;
    }

    public async Task SetSettingAsync(string key, string value)
    {
        await using var connection = await OpenAsync();
        var command = connection.CreateCommand();
        command.CommandText = """
            INSERT INTO settings (key, value) VALUES ($key, $value)
            ON CONFLICT(key) DO UPDATE SET value = $value;
            """;
        command.Parameters.AddWithValue("$key", key);
        command.Parameters.AddWithValue("$value", value);
        await command.ExecuteNonQueryAsync();
    }

    public async Task AddAuditAsync(string user, string action, string detail)
    {
        await using var connection = await OpenAsync();
        var command = connection.CreateCommand();
        command.CommandText = "INSERT INTO audit (timestamp, user, action, detail) VALUES ($timestamp, $user, $action, $detail)";
        command.Parameters.AddWithValue("$timestamp", DateTime.UtcNow.ToString("o"));
        command.Parameters.AddWithValue("$user", user);
        command.Parameters.AddWithValue("$action", action);
        command.Parameters.AddWithValue("$detail", detail);
        await command.ExecuteNonQueryAsync();
    }

    public async Task<IReadOnlyList<AuditRecord>> GetAuditAsync(int limit)
    {
        await using var connection = await OpenAsync();
        var command = connection.CreateCommand();
        command.CommandText = "SELECT id, timestamp, user, action, detail FROM audit ORDER BY id DESC LIMIT $limit";
        command.Parameters.AddWithValue("$limit", limit);
        var records = new List<AuditRecord>();
        await using var reader = await command.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            records.Add(new AuditRecord(reader.GetInt64(0), reader.GetString(1), reader.GetString(2), reader.GetString(3), reader.GetString(4)));
        }
        return records;
    }

    private async Task<SqliteConnection> OpenAsync()
    {
        var connection = new SqliteConnection(_connectionString);
        await connection.OpenAsync();
        return connection;
    }

    private static UserRecord ReadUser(SqliteDataReader reader) =>
        new(reader.GetInt64(0), reader.GetString(1), reader.GetString(2), reader.GetString(3), reader.GetString(4));

    private static UserProgress ReadProgress(SqliteDataReader reader) => new(
        reader.GetInt64(0),
        new ProgressRecord(
            reader.GetString(1),
            reader.GetString(2),
            reader.GetInt32(3),
            reader.GetInt32(4),
            reader.GetInt32(5) != 0,
            reader.GetInt32(6),
            reader.GetString(7),
            reader.GetString(8),
            reader.GetString(9)));
}
