using System.Net;
using System.Text.Json;

namespace PSDojo.Web.Tests;

public class ToggleTests
{
    private static readonly object Code = new { code = "$CheckTime = Get-Date" };

    [Fact]
    public async Task The_app_starts_and_works_with_no_runner_present()
    {
        using var factory = new DojoFactory(approveAll: true);
        var client = await factory.LoginAsync("anna");

        Assert.Equal(HttpStatusCode.OK, (await client.GetAsync("/api/health")).StatusCode);
        var page = await client.GetAsync("/");
        Assert.Equal(HttpStatusCode.OK, page.StatusCode);
        Assert.Contains("PSDojo", await page.Content.ReadAsStringAsync());

        var me = await (await client.GetAsync("/api/me")).JsonAsync();
        Assert.Equal("Off", me.GetProperty("execution").GetProperty("mode").GetString());
        Assert.False(me.GetProperty("execution").GetProperty("runnerConfigured").GetBoolean());
        Assert.False(me.GetProperty("execution").GetProperty("enabledForMe").GetBoolean());

        var modules = await (await client.GetAsync("/api/modules")).JsonAsync();
        Assert.Equal(8, modules.GetProperty("total").GetInt32());
        Assert.Equal(HttpStatusCode.OK, (await client.GetAsync("/api/exercises/m01-e01")).StatusCode);
    }

    [Theory]
    [InlineData("anna", "learner")]
    [InlineData("rita", "reviewer")]
    [InlineData("tom", "trainer")]
    [InlineData("admin", "admin")]
    public async Task Off_blocks_run_and_check_at_the_api_for_every_role(string name, string role)
    {
        var runner = new FakeRunner();
        using var factory = new DojoFactory(approveAll: true).WithRunner(runner);
        var client = await factory.LoginWithRoleAsync(name, role);

        foreach (var action in new[] { "run", "check" })
        {
            var response = await client.PostAsync($"/api/exercises/m01-e01/{action}", Code);
            Assert.Equal(HttpStatusCode.Forbidden, response.StatusCode);
            Assert.Equal("execution_disabled", (await response.JsonAsync()).GetProperty("error").GetString());
        }
        Assert.Empty(runner.Requests);
    }

    [Fact]
    public async Task Pilot_blocks_users_outside_the_allow_list()
    {
        var runner = new FakeRunner();
        using var factory = new DojoFactory(approveAll: true).WithRunner(runner);
        var admin = await factory.LoginAsync("admin");
        var change = await admin.PostAsync("/api/admin/execution", new { mode = "Pilot", allowList = new[] { "Paula" } });
        Assert.Equal(HttpStatusCode.OK, change.StatusCode);

        var outsider = await factory.LoginAsync("anna");
        var blocked = await outsider.PostAsync("/api/exercises/m01-e01/check", Code);
        Assert.Equal(HttpStatusCode.Forbidden, blocked.StatusCode);
        Assert.Equal(HttpStatusCode.Forbidden, (await outsider.PostAsync("/api/exercises/m01-e01/run", Code)).StatusCode);
        Assert.Equal(HttpStatusCode.Forbidden, (await admin.PostAsync("/api/exercises/m01-e01/run", Code)).StatusCode);
        Assert.Empty(runner.Requests);

        var pilot = await factory.LoginAsync("paula");
        var allowed = await pilot.PostAsync("/api/exercises/m01-e01/check", Code);
        Assert.Equal(HttpStatusCode.OK, allowed.StatusCode);
        Assert.True((await allowed.JsonAsync()).GetProperty("passed").GetBoolean());
        Assert.Single(runner.Requests);

        var me = await (await pilot.GetAsync("/api/me")).JsonAsync();
        Assert.True(me.GetProperty("execution").GetProperty("enabledForMe").GetBoolean());
        var other = await (await outsider.GetAsync("/api/me")).JsonAsync();
        Assert.False(other.GetProperty("execution").GetProperty("enabledForMe").GetBoolean());
    }

    [Fact]
    public async Task On_enables_execution_for_everyone()
    {
        var runner = new FakeRunner();
        using var factory = new DojoFactory(approveAll: true).WithRunner(runner);
        var admin = await factory.LoginAsync("admin");
        await admin.PostAsync("/api/admin/execution", new { mode = "On", allowList = Array.Empty<string>() });

        var learner = await factory.LoginAsync("anna");
        var run = await learner.PostAsync("/api/exercises/m01-e01/run", Code);
        Assert.Equal(HttpStatusCode.OK, run.StatusCode);
        Assert.Equal("fake output", (await run.JsonAsync()).GetProperty("output").GetString());
    }

    [Fact]
    public async Task Pilot_and_On_without_a_runner_answer_503_and_never_crash()
    {
        using var factory = new DojoFactory(approveAll: true);
        var admin = await factory.LoginAsync("admin");
        await admin.PostAsync("/api/admin/execution", new { mode = "On", allowList = Array.Empty<string>() });
        var learner = await factory.LoginAsync("anna");
        var response = await learner.PostAsync("/api/exercises/m01-e01/check", Code);
        Assert.Equal(HttpStatusCode.ServiceUnavailable, response.StatusCode);
        Assert.Equal("runner_not_configured", (await response.JsonAsync()).GetProperty("error").GetString());
    }

    [Theory]
    [InlineData("anna", "learner")]
    [InlineData("rita", "reviewer")]
    [InlineData("tom", "trainer")]
    public async Task Only_the_admin_role_can_read_or_change_the_setting(string name, string role)
    {
        using var factory = new DojoFactory(approveAll: true);
        var client = await factory.LoginWithRoleAsync(name, role);
        Assert.Equal(HttpStatusCode.Forbidden, (await client.GetAsync("/api/admin/execution")).StatusCode);
        Assert.Equal(HttpStatusCode.Forbidden, (await client.PostAsync("/api/admin/execution", new { mode = "On", allowList = Array.Empty<string>() })).StatusCode);
        Assert.Equal(HttpStatusCode.Forbidden, (await client.GetAsync("/api/admin/audit")).StatusCode);

        var anonymous = factory.Anonymous();
        Assert.Equal(HttpStatusCode.Unauthorized, (await anonymous.PostAsync("/api/admin/execution", new { mode = "On", allowList = Array.Empty<string>() })).StatusCode);

        var admin = await factory.LoginAsync("admin");
        var state = await (await admin.GetAsync("/api/admin/execution")).JsonAsync();
        Assert.Equal("Off", state.GetProperty("mode").GetString());
    }

    [Fact]
    public async Task Every_change_is_written_to_the_audit_log_with_user_and_timestamp()
    {
        using var factory = new DojoFactory(approveAll: true);
        var admin = await factory.LoginAsync("admin");
        var before = DateTime.UtcNow.AddSeconds(-2);
        await admin.PostAsync("/api/admin/execution", new { mode = "Pilot", allowList = new[] { "paula" } });
        await admin.PostAsync("/api/admin/execution", new { mode = "Off", allowList = Array.Empty<string>() });

        var audit = await (await admin.GetAsync("/api/admin/audit")).JsonAsync();
        var entries = audit.GetProperty("entries").EnumerateArray().Where(entry => entry.GetProperty("action").GetString() == "BrowserExecution.Changed").ToList();
        Assert.Equal(2, entries.Count);
        Assert.All(entries, entry =>
        {
            Assert.Equal("admin", entry.GetProperty("user").GetString());
            var stamp = DateTime.Parse(entry.GetProperty("timestamp").GetString()!, null, System.Globalization.DateTimeStyles.RoundtripKind);
            Assert.InRange(stamp, before, DateTime.UtcNow.AddSeconds(2));
        });
        Assert.Contains("mode Pilot -> Off", entries[0].GetProperty("detail").GetString());
        Assert.Contains("mode Off -> Pilot", entries[1].GetProperty("detail").GetString());
        Assert.Contains("paula", entries[1].GetProperty("detail").GetString());
    }

    [Fact]
    public async Task A_deployment_can_lock_the_setting_in_configuration()
    {
        var runner = new FakeRunner();
        using var factory = new DojoFactory(approveAll: true)
            .WithRunner(runner)
            .WithSetting("BrowserExecution:Mode", "Off")
            .WithSetting("BrowserExecution:Locked", "true");
        var admin = await factory.LoginAsync("admin");
        await factory.Store.SetSettingAsync("BrowserExecution.Mode", "On");

        var change = await admin.PostAsync("/api/admin/execution", new { mode = "On", allowList = Array.Empty<string>() });
        Assert.Equal(HttpStatusCode.Conflict, change.StatusCode);
        Assert.Equal("locked", (await change.JsonAsync()).GetProperty("error").GetString());

        var state = await (await admin.GetAsync("/api/admin/execution")).JsonAsync();
        Assert.Equal("Off", state.GetProperty("mode").GetString());
        Assert.True(state.GetProperty("locked").GetBoolean());
        Assert.Equal(HttpStatusCode.Forbidden, (await admin.PostAsync("/api/exercises/m01-e01/run", Code)).StatusCode);
        Assert.Empty(runner.Requests);
    }

    [Fact]
    public async Task Configuration_can_set_the_mode_and_the_allow_list()
    {
        var runner = new FakeRunner();
        using var factory = new DojoFactory(approveAll: true)
            .WithRunner(runner)
            .WithSetting("BrowserExecution:Mode", "Pilot")
            .WithSetting("BrowserExecution:AllowList:0", "paula");
        var pilot = await factory.LoginAsync("paula");
        var outsider = await factory.LoginAsync("anna");
        Assert.Equal(HttpStatusCode.OK, (await pilot.PostAsync("/api/exercises/m01-e01/run", Code)).StatusCode);
        Assert.Equal(HttpStatusCode.Forbidden, (await outsider.PostAsync("/api/exercises/m01-e01/run", Code)).StatusCode);
    }

    [Fact]
    public async Task An_unknown_mode_is_rejected_and_the_setting_stays_Off()
    {
        using var factory = new DojoFactory(approveAll: true);
        var admin = await factory.LoginAsync("admin");
        Assert.Equal(HttpStatusCode.BadRequest, (await admin.PostAsync("/api/admin/execution", new { mode = "Maybe", allowList = Array.Empty<string>() })).StatusCode);
        Assert.Equal(HttpStatusCode.BadRequest, (await admin.PostAsync("/api/admin/execution", new { mode = "7", allowList = Array.Empty<string>() })).StatusCode);
        var state = await (await admin.GetAsync("/api/admin/execution")).JsonAsync();
        Assert.Equal("Off", state.GetProperty("mode").GetString());
    }

    [Fact]
    public async Task A_passed_check_completes_the_exercise_and_a_failed_one_counts_an_attempt()
    {
        var runner = new FakeRunner { Passes = false };
        using var factory = new DojoFactory(approveAll: true).WithRunner(runner).WithSetting("BrowserExecution:Mode", "On");
        var learner = await factory.LoginAsync("anna");

        var failed = await (await learner.PostAsync("/api/exercises/m01-e01/check", Code)).JsonAsync();
        Assert.False(failed.GetProperty("passed").GetBoolean());
        Assert.Equal("4", failed.GetProperty("expected").GetString());
        Assert.Contains("Cmdlets return objects", failed.GetProperty("concept").GetProperty("en").GetString());

        runner.Passes = true;
        await learner.PostAsync("/api/exercises/m01-e01/check", Code);
        var exercise = await (await learner.GetAsync("/api/exercises/m01-e01")).JsonAsync();
        Assert.Equal("completed", exercise.GetProperty("state").GetString());
        Assert.Equal(2, exercise.GetProperty("attempts").GetInt32());
        Assert.Equal(HttpStatusCode.OK, (await learner.GetAsync("/api/exercises/m01-e02")).StatusCode);
    }

    [Fact]
    public async Task Runs_are_rate_limited_per_user()
    {
        var runner = new FakeRunner();
        using var factory = new DojoFactory(approveAll: true)
            .WithRunner(runner)
            .WithSetting("BrowserExecution:Mode", "On")
            .WithSetting("Runner:RunsPerMinute", "3");
        var anna = await factory.LoginAsync("anna");
        var ben = await factory.LoginAsync("ben");

        for (var index = 0; index < 3; index++)
        {
            Assert.Equal(HttpStatusCode.OK, (await anna.PostAsync("/api/exercises/m01-e01/run", Code)).StatusCode);
        }
        var limited = await anna.PostAsync("/api/exercises/m01-e01/run", Code);
        Assert.Equal((HttpStatusCode)429, limited.StatusCode);
        Assert.True(limited.Headers.Contains("Retry-After"));
        Assert.Equal((HttpStatusCode)429, (await anna.PostAsync("/api/exercises/m01-e01/check", Code)).StatusCode);
        Assert.Equal(HttpStatusCode.OK, (await ben.PostAsync("/api/exercises/m01-e01/run", Code)).StatusCode);
        Assert.Equal(4, runner.Requests.Count);
    }

    [Fact]
    public async Task Quizzes_and_oversized_code_are_never_sent_to_the_runner()
    {
        var runner = new FakeRunner();
        using var factory = new DojoFactory(approved: ["m01-e08", "m01-e01"]).WithRunner(runner).WithSetting("BrowserExecution:Mode", "On");
        var learner = await factory.LoginAsync("anna");
        Assert.Equal(HttpStatusCode.BadRequest, (await learner.PostAsync("/api/exercises/m01-e08/run", Code)).StatusCode);
        Assert.Equal(HttpStatusCode.BadRequest, (await learner.PostAsync("/api/exercises/m01-e01/run", new { code = new string('a', 100_001) })).StatusCode);
        Assert.Equal(HttpStatusCode.BadRequest, (await learner.PostAsync("/api/exercises/m01-e01/run", new { code = "" })).StatusCode);
        Assert.Empty(runner.Requests);
    }

    [Fact]
    public async Task State_changing_requests_need_the_request_header()
    {
        using var factory = new DojoFactory(approveAll: true);
        var client = factory.CreateClient();
        var response = await client.PostAsync("/api/login", new { name = "anna" });
        Assert.Equal(HttpStatusCode.BadRequest, response.StatusCode);
        Assert.Equal("missing_request_header", JsonDocument.Parse(await response.Content.ReadAsStringAsync()).RootElement.GetProperty("error").GetString());
    }
}
