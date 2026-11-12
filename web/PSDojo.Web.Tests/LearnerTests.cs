using System.Net;

namespace PSDojo.Web.Tests;

public class LearnerTests
{
    private static readonly Dictionary<string, string> RightAnswers = new()
    {
        ["1"] = "c", ["2"] = "a", ["3"] = "d", ["4"] = "b", ["5"] = "c", ["6"] = "d", ["7"] = "a", ["8"] = "b", ["9"] = "c", ["10"] = "a",
    };

    [Theory]
    [InlineData("a")]
    [InlineData("anna maria")]
    [InlineData("<script>")]
    [InlineData("")]
    public async Task Invalid_names_cannot_sign_in(string name)
    {
        using var factory = new DojoFactory(approveAll: true);
        var client = factory.Anonymous();
        Assert.Equal(HttpStatusCode.BadRequest, (await client.PostAsync("/api/login", new { name })).StatusCode);
    }

    [Fact]
    public async Task Sign_in_creates_a_learner_and_configured_admins_get_the_admin_role()
    {
        using var factory = new DojoFactory(approveAll: true);
        var learner = await (await (await factory.LoginAsync("Anna.Keller")).GetAsync("/api/me")).JsonAsync();
        Assert.Equal("anna.keller", learner.GetProperty("name").GetString());
        Assert.Equal("learner", learner.GetProperty("role").GetString());
        var admin = await (await (await factory.LoginAsync("Admin")).GetAsync("/api/me")).JsonAsync();
        Assert.Equal("admin", admin.GetProperty("role").GetString());
    }

    [Fact]
    public async Task Sign_out_ends_the_session()
    {
        using var factory = new DojoFactory(approveAll: true);
        var client = await factory.LoginAsync("anna");
        await client.PostAsync("/api/logout", new { });
        Assert.Equal(HttpStatusCode.Unauthorized, (await client.GetAsync("/api/modules")).StatusCode);
    }

    [Fact]
    public async Task The_exercise_is_delivered_in_German_and_English()
    {
        using var factory = new DojoFactory(approveAll: true);
        var learner = await factory.LoginAsync("anna");
        var exercise = await (await learner.GetAsync("/api/exercises/m01-e01")).JsonAsync();
        Assert.Contains("Cmdlets erledigen die Arbeit", exercise.GetProperty("lesson").GetProperty("de").GetString());
        Assert.Contains("Cmdlets do the work", exercise.GetProperty("lesson").GetProperty("en").GetString());
        Assert.Contains("<pre><code", exercise.GetProperty("lesson").GetProperty("en").GetString());
        Assert.Contains("Druckserver PRN-01", exercise.GetProperty("task").GetProperty("de").GetString());
        Assert.Equal("m01-e02", exercise.GetProperty("next").GetString() ?? "m01-e02");
    }

    [Fact]
    public async Task Locked_exercises_are_refused()
    {
        using var factory = new DojoFactory(approveAll: true);
        var learner = await factory.LoginAsync("anna");
        var response = await learner.GetAsync("/api/exercises/m01-e03");
        Assert.Equal((HttpStatusCode)423, response.StatusCode);
        Assert.Equal("m01-e02", (await response.JsonAsync()).GetProperty("missing")[0].GetString());
        Assert.Equal((HttpStatusCode)423, (await learner.PostAsync("/api/exercises/m01-e03/hint", new { })).StatusCode);
        Assert.Equal((HttpStatusCode)423, (await learner.PostAsync("/api/exercises/m01-e08/quiz", new { answers = RightAnswers })).StatusCode);
    }

    [Fact]
    public async Task The_solution_unlocks_only_after_the_third_hint_and_viewing_it_is_recorded()
    {
        using var factory = new DojoFactory(approveAll: true);
        var learner = await factory.LoginAsync("anna");

        var locked = await learner.PostAsync("/api/exercises/m01-e01/solution", new { });
        Assert.Equal(HttpStatusCode.Forbidden, locked.StatusCode);
        Assert.DoesNotContain("Get-Date", await locked.Content.ReadAsStringAsync());

        for (var level = 1; level <= 3; level++)
        {
            var hint = await (await learner.PostAsync("/api/exercises/m01-e01/hint", new { })).JsonAsync();
            Assert.Equal(level, hint.GetProperty("level").GetInt32());
            Assert.Equal(level == 3, hint.GetProperty("solutionUnlocked").GetBoolean());
            Assert.False(string.IsNullOrWhiteSpace(hint.GetProperty("text").GetProperty("de").GetString()));
            if (level == 2)
            {
                Assert.Equal(HttpStatusCode.Forbidden, (await learner.PostAsync("/api/exercises/m01-e01/solution", new { })).StatusCode);
            }
        }
        var fourth = await (await learner.PostAsync("/api/exercises/m01-e01/hint", new { })).JsonAsync();
        Assert.Equal(3, fourth.GetProperty("level").GetInt32());

        var solution = await (await learner.PostAsync("/api/exercises/m01-e01/solution", new { })).JsonAsync();
        Assert.Contains("$CheckTime = Get-Date", solution.GetProperty("solution").GetString());

        var user = await factory.Store.GetUserByNameAsync("anna");
        var record = (await factory.Store.GetProgressAsync(user!.Id)).Single();
        Assert.Equal(3, record.Hints);
        Assert.True(record.SolutionViewed);
    }

    [Fact]
    public async Task A_quiz_is_graded_on_the_server_with_the_80_percent_pass_mark()
    {
        using var factory = new DojoFactory(approved: ["m01-e08"]);
        var learner = await factory.LoginAsync("anna");

        var seven = new Dictionary<string, string>(RightAnswers) { ["3"] = "a", ["4"] = "a", ["7"] = "b" };
        var failed = await (await learner.PostAsync("/api/exercises/m01-e08/quiz", new { answers = seven })).JsonAsync();
        Assert.False(failed.GetProperty("passed").GetBoolean());
        Assert.Equal(70, failed.GetProperty("score").GetInt32());
        Assert.Equal([3, 4, 7], failed.GetProperty("wrong").EnumerateArray().Select(item => item.GetInt32()).ToList());
        Assert.False(failed.TryGetProperty("answers", out _));

        var eight = new Dictionary<string, string>(RightAnswers) { ["1"] = "a", ["2"] = "b" };
        var passed = await (await learner.PostAsync("/api/exercises/m01-e08/quiz", new { answers = eight })).JsonAsync();
        Assert.True(passed.GetProperty("passed").GetBoolean());
        Assert.Equal(80, passed.GetProperty("score").GetInt32());

        var map = await (await learner.GetAsync("/api/modules")).JsonAsync();
        var module = map.GetProperty("modules")[0];
        Assert.Equal(1, module.GetProperty("completed").GetInt32());
        Assert.Contains("gsv", module.GetProperty("productionNote").GetProperty("en").GetString());

        var user = await factory.Store.GetUserByNameAsync("anna");
        Assert.Equal(2, (await factory.Store.GetProgressAsync(user!.Id)).Single().Attempts);
    }

    [Fact]
    public async Task The_production_note_appears_only_when_the_module_is_completed()
    {
        using var factory = new DojoFactory(approved: ["m01-e01", "m01-e08"]);
        var learner = await factory.LoginAsync("anna");
        var map = await (await learner.GetAsync("/api/modules")).JsonAsync();
        Assert.Equal(System.Text.Json.JsonValueKind.Null, map.GetProperty("modules")[0].GetProperty("productionNote").ValueKind);
    }

    [Fact]
    public async Task An_uploaded_local_report_brings_web_progress_in_sync()
    {
        using var factory = new DojoFactory(approveAll: true);
        var learner = await factory.LoginAsync("anna");
        var report = new
        {
            kind = "PSDojoReport",
            schema = 1,
            learner = "someone-else",
            exercises = new object[]
            {
                new { id = "m01-e01", status = "completed", attempts = 3, hints = 2, solutionViewed = false, seconds = 600, completedAt = "2026-11-01T10:00:00Z" },
                new { id = "m01-e02", status = "completed", attempts = 1, hints = 0, solutionViewed = true, seconds = 120, completedAt = "2026-11-01T10:10:00Z" },
                new { id = "m01-e03", status = "open", attempts = 4, hints = 9, solutionViewed = false, seconds = 50, completedAt = "" },
            },
        };
        var result = await (await learner.PostAsync("/api/progress/import", report)).JsonAsync();
        Assert.Equal(3, result.GetProperty("matched").GetInt32());
        Assert.Equal(2, result.GetProperty("newlyCompleted").GetInt32());

        var map = await (await learner.GetAsync("/api/modules")).JsonAsync();
        Assert.Equal(2, map.GetProperty("completed").GetInt32());
        var states = map.GetProperty("modules")[0].GetProperty("exercises").EnumerateArray().Take(4).Select(item => item.GetProperty("state").GetString()).ToList();
        Assert.Equal(["completed", "completed", "open", "locked"], states);

        var user = await factory.Store.GetUserByNameAsync("anna");
        var records = (await factory.Store.GetProgressAsync(user!.Id)).ToDictionary(record => record.ExerciseId);
        Assert.Equal("import", records["m01-e01"].Source);
        Assert.Equal(3, records["m01-e03"].Hints);
        Assert.Equal(4, records["m01-e03"].Attempts);

        var again = await (await learner.PostAsync("/api/progress/import", report)).JsonAsync();
        Assert.Equal(0, again.GetProperty("newlyCompleted").GetInt32());
    }

    [Theory]
    [InlineData("{\"kind\":\"something\"}")]
    [InlineData("[1,2,3]")]
    [InlineData("{\"kind\":\"PSDojoReport\"}")]
    public async Task Files_that_are_not_reports_are_rejected(string json)
    {
        using var factory = new DojoFactory(approveAll: true);
        var learner = await factory.LoginAsync("anna");
        var response = await learner.PostAsync("/api/progress/import", new StringContent(json, System.Text.Encoding.UTF8, "application/json"));
        Assert.Equal(HttpStatusCode.BadRequest, response.StatusCode);
    }
}
