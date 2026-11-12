using System.Text.Json;
using Microsoft.Extensions.Options;
using PSDojo.Web.Auth;
using PSDojo.Web.Data;

namespace PSDojo.Web.Execution;

public enum ExecutionMode
{
    Off,
    Pilot,
    On,
}

public sealed record ExecutionState(ExecutionMode Mode, bool Locked, IReadOnlyList<string> AllowList);

public sealed record ExecutionChange(bool Changed, string? Error, ExecutionState State);

/// <summary>
/// The single place that decides whether learner code may be executed for a user.
/// Every execution endpoint asks this class. Hiding buttons in the browser is never the control.
/// </summary>
public sealed class ExecutionPolicy(IDojoStore store, IOptions<BrowserExecutionOptions> options)
{
    private const string ModeKey = "BrowserExecution.Mode";
    private const string AllowListKey = "BrowserExecution.AllowList";

    public async Task<ExecutionState> GetStateAsync()
    {
        var configured = options.Value;
        var configuredMode = ParseMode(configured.Mode) ?? ExecutionMode.Off;
        var configuredList = Normalize(configured.AllowList);
        if (configured.Locked)
        {
            return new ExecutionState(configuredMode, true, configuredList);
        }
        var storedMode = ParseMode(await store.GetSettingAsync(ModeKey));
        var storedList = await store.GetSettingAsync(AllowListKey);
        var list = storedList is null ? configuredList : Normalize(JsonSerializer.Deserialize<List<string>>(storedList) ?? []);
        return new ExecutionState(storedMode ?? configuredMode, false, list);
    }

    public async Task<bool> IsAllowedAsync(string userName)
    {
        var state = await GetStateAsync();
        return state.Mode switch
        {
            ExecutionMode.On => true,
            ExecutionMode.Pilot => state.AllowList.Contains(UserSessions.Normalize(userName)),
            _ => false,
        };
    }

    public async Task<ExecutionChange> SetAsync(string mode, IEnumerable<string> allowList, string actor)
    {
        var current = await GetStateAsync();
        if (current.Locked)
        {
            return new ExecutionChange(false, "locked", current);
        }
        var parsed = ParseMode(mode);
        if (parsed is null)
        {
            return new ExecutionChange(false, "invalid_mode", current);
        }
        var list = Normalize(allowList);
        if (list.Any(name => !UserSessions.IsValidName(name)))
        {
            return new ExecutionChange(false, "invalid_name", current);
        }
        await store.SetSettingAsync(ModeKey, parsed.Value.ToString());
        await store.SetSettingAsync(AllowListKey, JsonSerializer.Serialize(list));
        var detail = $"mode {current.Mode} -> {parsed.Value}; allow list [{string.Join(", ", current.AllowList)}] -> [{string.Join(", ", list)}]";
        await store.AddAuditAsync(actor, "BrowserExecution.Changed", detail);
        return new ExecutionChange(true, null, new ExecutionState(parsed.Value, false, list));
    }

    private static ExecutionMode? ParseMode(string? value) =>
        Enum.TryParse<ExecutionMode>(value, true, out var mode) && Enum.IsDefined(mode) ? mode : null;

    private static List<string> Normalize(IEnumerable<string> names) =>
        names.Select(UserSessions.Normalize).Where(name => name.Length > 0).Distinct().OrderBy(name => name, StringComparer.Ordinal).ToList();
}
