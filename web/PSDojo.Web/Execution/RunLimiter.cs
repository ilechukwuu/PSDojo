using System.Collections.Concurrent;
using Microsoft.Extensions.Options;

namespace PSDojo.Web.Execution;

/// <summary>
/// Sliding one-minute window per user. Runs and checks share one budget.
/// </summary>
public sealed class RunLimiter(IOptions<RunnerOptions> options, TimeProvider time)
{
    private readonly ConcurrentDictionary<string, Queue<DateTimeOffset>> _windows = new();

    public bool TryAcquire(string user, out int retryAfterSeconds)
    {
        var limit = Math.Max(1, options.Value.RunsPerMinute);
        var now = time.GetUtcNow();
        var window = _windows.GetOrAdd(user, _ => new Queue<DateTimeOffset>());
        lock (window)
        {
            while (window.Count > 0 && now - window.Peek() >= TimeSpan.FromMinutes(1))
            {
                window.Dequeue();
            }
            if (window.Count >= limit)
            {
                retryAfterSeconds = Math.Max(1, (int)Math.Ceiling((window.Peek() + TimeSpan.FromMinutes(1) - now).TotalSeconds));
                return false;
            }
            window.Enqueue(now);
            retryAfterSeconds = 0;
            return true;
        }
    }
}
