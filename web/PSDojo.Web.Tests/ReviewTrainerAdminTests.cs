using System.Net;

namespace PSDojo.Web.Tests;

public class ReviewTests
{
    [Fact]
    public async Task A_reviewer_sees_drafts_with_lesson_task_solution_and_tests()
    {
        using var factory = new DojoFactory();
        var reviewer = await factory.LoginWithRoleAsync("rita", "reviewer");

        var list = await (await reviewer.GetAsync("/api/review/items")).JsonAsync();
        Assert.Equal(8, list.GetProperty("items").GetArrayLength());

        var item = await (await reviewer.GetAsync("/api/review/items/m01-e08")).JsonAsync();
        Assert.Contains("Modul 1", item.GetProperty("lesson").GetProperty("de").GetString());
        Assert.Contains("Module 1", item.GetProperty("lesson").GetProperty("en").GetString());
        Assert.Contains("$Answer1 = 'c'", item.GetProperty("solution").GetString());
        Assert.Contains("Describe 'Quiz'", item.GetProperty("tests").GetString());
        Assert.Contains("$Answer3 = 'a'", item.GetProperty("wrong").GetString());
        Assert.Equal(3, item.GetProperty("hints").GetProperty("de").GetArrayLength());
        Assert.Equal("c", item.GetProperty("questions")[0].GetProperty("answer").GetString());
    }

    [Fact]
    public async Task Approval_takes_two_different_reviewers_and_then_the_learner_sees_the_exercise()
    {
        using var factory = new DojoFactory();
        var rita = await factory.LoginWithRoleAsync("rita", "reviewer");
        var sven = await factory.LoginWithRoleAsync("sven", "reviewer");
        var learner = await factory.LoginAsync("anna");

        var first = await (await rita.PostAsync("/api/review/items/m01-e01/approve", new { comment = "German checked" })).JsonAsync();
        Assert.Equal("reviewed", first.GetProperty("status").GetString());
        Assert.Equal(0, (await (await learner.GetAsync("/api/modules")).JsonAsync()).GetProperty("total").GetInt32());

        var same = await rita.PostAsync("/api/review/items/m01-e01/approve", new { comment = "" });
        Assert.Equal(HttpStatusCode.Conflict, same.StatusCode);
        Assert.Equal("same_reviewer", (await same.JsonAsync()).GetProperty("error").GetString());

        var second = await (await sven.PostAsync("/api/review/items/m01-e01/approve", new { comment = "" })).JsonAsync();
        Assert.Equal("approved", second.GetProperty("status").GetString());
        Assert.Equal(1, (await (await learner.GetAsync("/api/modules")).JsonAsync()).GetProperty("total").GetInt32());

        Assert.Equal(HttpStatusCode.Conflict, (await sven.PostAsync("/api/review/items/m01-e01/approve", new { comment = "" })).StatusCode);
    }

    [Fact]
    public async Task The_review_is_recorded_in_meta_json_in_the_layout_of_the_module()
    {
        using var factory = new DojoFactory();
        var rita = await factory.LoginWithRoleAsync("rita", "reviewer");
        var before = DateTime.UtcNow.AddSeconds(-2);
        await rita.PostAsync("/api/review/items/m01-e02/approve", new { comment = "Checked \"quotes\" and umlauts" });

        var meta = factory.ReadContent("m01/m01-e02/meta.json");
        Assert.StartsWith("{\n  \"id\": \"m01-e02\",\n  \"module\": \"m01\",\n  \"title\": {\n    \"de\": ", meta);
        Assert.Contains("\"prerequisites\": [\"m01-e01\"],\n  \"status\": \"reviewed\",", meta);
        Assert.Contains("ausschließlich", meta);
        Assert.Contains("\"comment\": \"Checked \\\"quotes\\\" and umlauts\"", meta);
        Assert.EndsWith("}\n", meta);

        var item = await (await rita.GetAsync("/api/review/items/m01-e02")).JsonAsync();
        var entry = item.GetProperty("history")[0];
        Assert.Equal("rita", entry.GetProperty("reviewer").GetString());
        Assert.Equal("approve", entry.GetProperty("action").GetString());
        Assert.Equal("draft", entry.GetProperty("from").GetString());
        var stamp = DateTime.Parse(entry.GetProperty("timestamp").GetString()!, null, System.Globalization.DateTimeStyles.RoundtripKind);
        Assert.InRange(stamp, before, DateTime.UtcNow.AddSeconds(2));
    }

    [Fact]
    public async Task A_rejection_needs_a_comment_and_sends_the_exercise_back_to_draft()
    {
        using var factory = new DojoFactory(approved: ["m01-e01"]);
        var rita = await factory.LoginWithRoleAsync("rita", "reviewer");
        var learner = await factory.LoginAsync("anna");
        Assert.Equal(HttpStatusCode.OK, (await learner.GetAsync("/api/exercises/m01-e01")).StatusCode);

        Assert.Equal(HttpStatusCode.BadRequest, (await rita.PostAsync("/api/review/items/m01-e01/reject", new { comment = "  " })).StatusCode);
        var rejected = await (await rita.PostAsync("/api/review/items/m01-e01/reject", new { comment = "Hint 3 gives the answer away" })).JsonAsync();
        Assert.Equal("draft", rejected.GetProperty("status").GetString());
        Assert.Equal("Hint 3 gives the answer away", rejected.GetProperty("review").GetProperty("comment").GetString());

        Assert.Equal(HttpStatusCode.NotFound, (await learner.GetAsync("/api/exercises/m01-e01")).StatusCode);
        var list = await (await rita.GetAsync("/api/review/items")).JsonAsync();
        var item = list.GetProperty("items").EnumerateArray().Single(entry => entry.GetProperty("id").GetString() == "m01-e01");
        Assert.Equal("rita", item.GetProperty("review").GetProperty("reviewer").GetString());
    }

    [Fact]
    public async Task One_person_can_do_both_steps_only_when_configuration_allows_it()
    {
        using var factory = new DojoFactory().WithSetting("Review:AllowSameReviewer", "true");
        var rita = await factory.LoginWithRoleAsync("rita", "reviewer");
        await rita.PostAsync("/api/review/items/m01-e01/approve", new { comment = "" });
        var second = await (await rita.PostAsync("/api/review/items/m01-e01/approve", new { comment = "" })).JsonAsync();
        Assert.Equal("approved", second.GetProperty("status").GetString());
    }

    [Fact]
    public async Task Trainers_cannot_review_and_unknown_ids_are_not_found()
    {
        using var factory = new DojoFactory();
        var trainer = await factory.LoginWithRoleAsync("tom", "trainer");
        Assert.Equal(HttpStatusCode.Forbidden, (await trainer.GetAsync("/api/review/items")).StatusCode);
        var admin = await factory.LoginAsync("admin");
        Assert.Equal(HttpStatusCode.NotFound, (await admin.GetAsync("/api/review/items/m01-e99")).StatusCode);
        Assert.Equal(HttpStatusCode.NotFound, (await admin.PostAsync("/api/review/items/m01-e99/approve", new { comment = "" })).StatusCode);
    }
}

public class TrainerTests
{
    [Fact]
    public async Task The_overview_shows_completion_attempts_hints_and_the_hardest_exercises()
    {
        using var factory = new DojoFactory(approveAll: true);
        var anna = await factory.LoginAsync("anna");
        var ben = await factory.LoginAsync("ben");
        var trainer = await factory.LoginWithRoleAsync("tom", "trainer");

        await anna.PostAsync("/api/progress/import", new
        {
            kind = "PSDojoReport",
            exercises = new object[]
            {
                new { id = "m01-e01", status = "completed", attempts = 2, hints = 1, solutionViewed = false, seconds = 600, completedAt = "2026-11-01T10:00:00Z" },
                new { id = "m01-e02", status = "open", attempts = 5, hints = 3, solutionViewed = true, seconds = 300, completedAt = "" },
            },
        });
        await ben.PostAsync("/api/progress/import", new
        {
            kind = "PSDojoReport",
            exercises = new object[]
            {
                new { id = "m01-e01", status = "completed", attempts = 1, hints = 0, solutionViewed = false, seconds = 60, completedAt = "2026-11-02T10:00:00Z" },
                new { id = "m01-e02", status = "completed", attempts = 1, hints = 0, solutionViewed = false, seconds = 60, completedAt = "2026-11-02T10:05:00Z" },
            },
        });

        var overview = await (await trainer.GetAsync("/api/trainer/overview")).JsonAsync();
        var learners = overview.GetProperty("learners").EnumerateArray().ToDictionary(item => item.GetProperty("name").GetString()!);
        Assert.Equal(2, learners.Count);
        Assert.Equal(1, learners["anna"].GetProperty("completed").GetInt32());
        Assert.Equal(8, learners["anna"].GetProperty("total").GetInt32());
        Assert.Equal(13, learners["anna"].GetProperty("percent").GetInt32());
        Assert.Equal(7, learners["anna"].GetProperty("attempts").GetInt32());
        Assert.Equal(4, learners["anna"].GetProperty("hints").GetInt32());
        Assert.Equal(1, learners["anna"].GetProperty("solutionsViewed").GetInt32());
        Assert.Equal(15, learners["anna"].GetProperty("minutes").GetInt32());
        Assert.Equal(1, learners["anna"].GetProperty("modules")[0].GetProperty("completed").GetInt32());
        Assert.Equal(2, learners["ben"].GetProperty("completed").GetInt32());
        Assert.Equal(2, learners["ben"].GetProperty("imported").GetInt32());

        var hardest = overview.GetProperty("hardest");
        Assert.Equal("m01-e02", hardest[0].GetProperty("id").GetString());
        Assert.Equal(50, hardest[0].GetProperty("failRate").GetInt32());
        Assert.Equal(3, hardest[0].GetProperty("averageAttempts").GetDouble());
        Assert.Equal(1, hardest[0].GetProperty("notCompleted").GetInt32());
        Assert.Equal(0, hardest[1].GetProperty("failRate").GetInt32());
    }

    [Fact]
    public async Task Reviewers_cannot_open_the_trainer_page()
    {
        using var factory = new DojoFactory(approveAll: true);
        var reviewer = await factory.LoginWithRoleAsync("rita", "reviewer");
        Assert.Equal(HttpStatusCode.Forbidden, (await reviewer.GetAsync("/api/trainer/overview")).StatusCode);
    }
}

public class AdminTests
{
    [Fact]
    public async Task An_admin_assigns_roles_and_the_change_applies_at_once_and_is_audited()
    {
        using var factory = new DojoFactory();
        var admin = await factory.LoginAsync("admin");
        var rita = await factory.LoginAsync("rita");
        Assert.Equal(HttpStatusCode.Forbidden, (await rita.GetAsync("/api/review/items")).StatusCode);

        var change = await admin.PostAsync("/api/admin/users/rita/role", new { role = "reviewer" });
        Assert.Equal(HttpStatusCode.OK, change.StatusCode);
        Assert.Equal(HttpStatusCode.OK, (await rita.GetAsync("/api/review/items")).StatusCode);

        var audit = await (await admin.GetAsync("/api/admin/audit")).JsonAsync();
        var entry = audit.GetProperty("entries").EnumerateArray().First(item => item.GetProperty("action").GetString() == "User.RoleChanged");
        Assert.Equal("admin", entry.GetProperty("user").GetString());
        Assert.Equal("rita: learner -> reviewer", entry.GetProperty("detail").GetString());

        Assert.Equal(HttpStatusCode.BadRequest, (await admin.PostAsync("/api/admin/users/rita/role", new { role = "root" })).StatusCode);
        Assert.Equal(HttpStatusCode.NotFound, (await admin.PostAsync("/api/admin/users/nobody/role", new { role = "trainer" })).StatusCode);
        Assert.Equal(HttpStatusCode.Conflict, (await admin.PostAsync("/api/admin/users/admin/role", new { role = "learner" })).StatusCode);
    }
}
