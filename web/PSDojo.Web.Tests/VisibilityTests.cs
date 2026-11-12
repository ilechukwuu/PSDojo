using System.Net;

namespace PSDojo.Web.Tests;

public class VisibilityTests
{
    private static DojoFactory Mixed() => new DojoFactory(approved: ["m01-e01", "m01-e04"], reviewed: ["m01-e02"]);

    [Fact]
    public async Task The_module_map_lists_approved_exercises_only()
    {
        using var factory = Mixed();
        var learner = await factory.LoginAsync("anna");
        var response = await learner.GetAsync("/api/modules");
        var text = await response.Content.ReadAsStringAsync();
        var map = await response.JsonAsync();

        Assert.Equal(2, map.GetProperty("total").GetInt32());
        var ids = map.GetProperty("modules")[0].GetProperty("exercises").EnumerateArray().Select(item => item.GetProperty("id").GetString()).ToList();
        Assert.Equal(["m01-e01", "m01-e04"], ids);
        foreach (var hidden in new[] { "m01-e02", "m01-e03", "m01-e05", "m01-e06", "m01-e07", "m01-e08" })
        {
            Assert.DoesNotContain(hidden, text);
        }
    }

    [Theory]
    [InlineData("m01-e02")]
    [InlineData("m01-e03")]
    [InlineData("m01-e08")]
    public async Task Draft_and_reviewed_exercises_cannot_be_opened_hinted_solved_or_answered(string id)
    {
        var runner = new FakeRunner();
        using var factory = Mixed().WithRunner(runner).WithSetting("BrowserExecution:Mode", "On");
        var learner = await factory.LoginAsync("anna");

        var responses = new[]
        {
            await learner.GetAsync($"/api/exercises/{id}"),
            await learner.PostAsync($"/api/exercises/{id}/hint", new { }),
            await learner.PostAsync($"/api/exercises/{id}/solution", new { }),
            await learner.PostAsync($"/api/exercises/{id}/quiz", new { answers = new Dictionary<string, string> { ["1"] = "c" } }),
            await learner.PostAsync($"/api/exercises/{id}/run", new { code = "Get-Date" }),
            await learner.PostAsync($"/api/exercises/{id}/check", new { code = "Get-Date" }),
        };
        foreach (var response in responses)
        {
            Assert.Equal(HttpStatusCode.NotFound, response.StatusCode);
            var body = await response.Content.ReadAsStringAsync();
            Assert.DoesNotContain("Restart-Service", body);
            Assert.DoesNotContain("Get-Command", body);
            Assert.DoesNotContain("Verb", body);
        }
        Assert.Empty(runner.Requests);
    }

    [Fact]
    public async Task A_learner_cannot_reach_the_review_trainer_or_admin_api()
    {
        using var factory = Mixed();
        var learner = await factory.LoginAsync("anna");
        Assert.Equal(HttpStatusCode.Forbidden, (await learner.GetAsync("/api/review/items")).StatusCode);
        Assert.Equal(HttpStatusCode.Forbidden, (await learner.GetAsync("/api/review/items/m01-e02")).StatusCode);
        Assert.Equal(HttpStatusCode.Forbidden, (await learner.PostAsync("/api/review/items/m01-e02/approve", new { comment = "" })).StatusCode);
        Assert.Equal(HttpStatusCode.Forbidden, (await learner.GetAsync("/api/trainer/overview")).StatusCode);
        Assert.Equal(HttpStatusCode.Forbidden, (await learner.GetAsync("/api/admin/users")).StatusCode);
    }

    [Fact]
    public async Task Nothing_is_readable_without_signing_in()
    {
        using var factory = Mixed();
        var anonymous = factory.Anonymous();
        Assert.Equal(HttpStatusCode.Unauthorized, (await anonymous.GetAsync("/api/modules")).StatusCode);
        Assert.Equal(HttpStatusCode.Unauthorized, (await anonymous.GetAsync("/api/exercises/m01-e01")).StatusCode);
        Assert.Equal(HttpStatusCode.Unauthorized, (await anonymous.GetAsync("/api/review/items")).StatusCode);
    }

    [Theory]
    [InlineData("/content/m01/m01-e02/solution.ps1")]
    [InlineData("/content/m01/m01-e01/solution.ps1")]
    [InlineData("/m01/m01-e08/quiz.json")]
    [InlineData("/../../content/m01/m01-e02/meta.json")]
    public async Task Content_files_are_never_served_as_static_files(string path)
    {
        using var factory = Mixed();
        var learner = await factory.LoginAsync("anna");
        Assert.Equal(HttpStatusCode.NotFound, (await learner.GetAsync(path)).StatusCode);
    }

    [Fact]
    public async Task An_uploaded_report_cannot_complete_an_unapproved_exercise()
    {
        using var factory = Mixed();
        var learner = await factory.LoginAsync("anna");
        var report = new
        {
            kind = "PSDojoReport",
            exercises = new[]
            {
                new { id = "m01-e01", status = "completed", attempts = 2, hints = 1, solutionViewed = false, seconds = 300, completedAt = "2026-11-01T10:00:00Z" },
                new { id = "m01-e02", status = "completed", attempts = 1, hints = 0, solutionViewed = false, seconds = 100, completedAt = "2026-11-01T10:05:00Z" },
                new { id = "m01-e03", status = "completed", attempts = 1, hints = 0, solutionViewed = false, seconds = 100, completedAt = "2026-11-01T10:06:00Z" },
            },
        };
        var result = await (await learner.PostAsync("/api/progress/import", report)).JsonAsync();
        Assert.Equal(1, result.GetProperty("matched").GetInt32());
        Assert.Equal(2, result.GetProperty("ignored").GetInt32());

        var user = await factory.Store.GetUserByNameAsync("anna");
        var stored = await factory.Store.GetProgressAsync(user!.Id);
        Assert.Equal(["m01-e01"], stored.Select(record => record.ExerciseId).ToList());
    }

    [Fact]
    public async Task An_unapproved_prerequisite_does_not_lock_an_approved_exercise()
    {
        using var factory = Mixed();
        var learner = await factory.LoginAsync("anna");
        var map = await (await learner.GetAsync("/api/modules")).JsonAsync();
        var states = map.GetProperty("modules")[0].GetProperty("exercises").EnumerateArray().Select(item => item.GetProperty("state").GetString()).ToList();
        Assert.Equal(["open", "open"], states);
    }

    [Fact]
    public async Task The_exercise_payload_never_contains_the_solution_or_the_quiz_answers()
    {
        using var factory = new DojoFactory(approved: ["m01-e01", "m01-e08"]);
        var learner = await factory.LoginAsync("anna");

        var exercise = await (await learner.GetAsync("/api/exercises/m01-e01")).Content.ReadAsStringAsync();
        Assert.Contains("$CheckTime = $null", exercise);
        Assert.DoesNotContain("$CheckTime = Get-Date", exercise.Replace("\\u0024", "$"));
        Assert.DoesNotContain("BeforeAll", exercise);

        var quiz = await (await learner.GetAsync("/api/exercises/m01-e08")).Content.ReadAsStringAsync();
        Assert.Contains("\"questions\"", quiz);
        Assert.DoesNotContain("\"answer\"", quiz);
    }

    [Fact]
    public async Task With_everything_in_draft_a_learner_sees_an_empty_map()
    {
        using var factory = new DojoFactory();
        var learner = await factory.LoginAsync("anna");
        var map = await (await learner.GetAsync("/api/modules")).JsonAsync();
        Assert.Equal(0, map.GetProperty("total").GetInt32());
        Assert.Equal(0, map.GetProperty("modules").GetArrayLength());
    }
}
