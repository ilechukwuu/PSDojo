using System.Diagnostics;
using System.Net;
using System.Net.Http.Json;
using System.Text;

namespace PSDojo.Runner.Tests;

[Collection("runner")]
public class RunnerSecurityTests(RunnerFixture runner)
{
    [Fact]
    public async Task Run_returns_the_console_output()
    {
        var result = await runner.RunAsync("'Disk C: on FS-02 has ' + (40 + 2) + ' GB free'\nGet-Date -Year 2026 -Month 3 -Day 14 -Format 'yyyy-MM-dd'");
        Assert.Equal("ok", result.GetProperty("status").GetString());
        Assert.Equal("Disk C: on FS-02 has 42 GB free\n2026-03-14\n", result.GetProperty("output").GetString());
    }

    [Fact]
    public async Task The_network_is_blocked()
    {
        var code = """
            $interfaces = [System.Net.NetworkInformation.NetworkInterface]::GetAllNetworkInterfaces().Name -join ','
            "interfaces=$interfaces"
            try { $client = [System.Net.Sockets.TcpClient]::new(); $client.Connect('1.1.1.1', 443); 'tcp=CONNECTED' } catch { 'tcp=blocked' }
            try { $null = [System.Net.Dns]::GetHostAddresses('www.microsoft.com'); 'dns=RESOLVED' } catch { 'dns=blocked' }
            try { $null = Invoke-WebRequest -Uri 'https://www.microsoft.com' -TimeoutSec 5; 'http=REACHED' } catch { 'http=blocked' }
            try { $udp = [System.Net.Sockets.UdpClient]::new(); $udp.Connect('8.8.8.8', 53); $null = $udp.Send([byte[]](1, 2, 3), 3); 'udp=SENT' } catch { 'udp=blocked' }
            """;
        var output = (await runner.RunAsync(code)).GetProperty("output").GetString()!;
        Assert.Contains("interfaces=lo\n", output);
        Assert.Contains("tcp=blocked", output);
        Assert.Contains("dns=blocked", output);
        Assert.Contains("http=blocked", output);
        Assert.Contains("udp=blocked", output);
    }

    [Fact]
    public async Task The_timeout_kills_an_endless_loop_and_removes_the_container()
    {
        var watch = Stopwatch.StartNew();
        var result = await runner.RunAsync("'started'\nwhile ($true) { }");
        watch.Stop();
        Assert.Equal("timeout", result.GetProperty("status").GetString());
        Assert.Contains("started", result.GetProperty("output").GetString());
        Assert.InRange(watch.Elapsed.TotalSeconds, 14, 30);
        Assert.Empty(RunnerFixture.LeftoverContainers());
    }

    [Fact]
    public async Task A_fork_bomb_is_contained_by_the_process_limit()
    {
        var code = """
            $started = 0
            try {
                while ($started -lt 5000) {
                    $null = Start-Process -FilePath sleep -ArgumentList 60 -PassThru -ErrorAction Stop
                    $started++
                }
            } catch { "stopped=$($_.Exception.GetType().Name)" }
            "started=$started"
            """;
        var watch = Stopwatch.StartNew();
        var result = await runner.RunAsync(code);
        watch.Stop();
        var output = result.GetProperty("output").GetString()!;
        var started = int.Parse(System.Text.RegularExpressions.Regex.Match(output, "started=(\\d+)").Groups[1].Value);
        Assert.InRange(started, 1, 128);
        Assert.True(watch.Elapsed.TotalSeconds < 30);
        Assert.Empty(RunnerFixture.LeftoverContainers());
    }

    [Fact]
    public async Task A_shell_fork_bomb_does_not_hurt_the_host()
    {
        var before = Process.GetProcesses().Length;
        var watch = Stopwatch.StartNew();
        var result = await runner.RunAsync("bash -c ':(){ :|:& };:'\nStart-Sleep -Seconds 60");
        watch.Stop();
        Assert.Contains(result.GetProperty("status").GetString(), new[] { "timeout", "ok", "killed" });
        Assert.True(watch.Elapsed.TotalSeconds < 30);
        Assert.Empty(RunnerFixture.LeftoverContainers());
        Assert.InRange(Process.GetProcesses().Length, 0, before + 40);

        var after = await runner.RunAsync("'host still answers'");
        Assert.Equal("host still answers\n", after.GetProperty("output").GetString());
    }

    [Fact]
    public async Task Huge_output_is_capped_and_does_not_fill_the_memory_of_the_runner()
    {
        var before = GC.GetTotalMemory(true);
        var result = await runner.RunAsync("while ($true) { 'x' * 4000 }");
        var after = GC.GetTotalMemory(true);
        var output = result.GetProperty("output").GetString()!;
        Assert.Contains(result.GetProperty("status").GetString(), new[] { "timeout", "truncated" });
        Assert.InRange(Encoding.UTF8.GetByteCount(output), 60_000, 65_536);
        Assert.True(after - before < 30_000_000, $"runner memory grew by {after - before} bytes");
        Assert.Empty(RunnerFixture.LeftoverContainers());
    }

    [Fact]
    public async Task Large_output_that_ends_is_reported_as_truncated()
    {
        var result = await runner.RunAsync("1..3000 | ForEach-Object { 'line ' + $_ + ' ' + ('y' * 60) }");
        Assert.Equal("truncated", result.GetProperty("status").GetString());
        Assert.InRange(Encoding.UTF8.GetByteCount(result.GetProperty("output").GetString()!), 60_000, 65_536);
    }

    [Fact]
    public async Task A_memory_bomb_is_stopped_by_the_memory_limit()
    {
        var code = """
            $blocks = [System.Collections.Generic.List[byte[]]]::new()
            try { while ($true) { $block = [byte[]]::new(32MB); [Array]::Fill($block, [byte]1); $blocks.Add($block) } } catch { 'allocation failed' }
            "allocated=$($blocks.Count * 32)"
            """;
        var watch = Stopwatch.StartNew();
        var result = await runner.RunAsync(code);
        watch.Stop();
        var output = result.GetProperty("output").GetString()!;
        var match = System.Text.RegularExpressions.Regex.Match(output, "allocated=(\\d+)");
        if (match.Success)
        {
            Assert.InRange(int.Parse(match.Groups[1].Value), 0, 384);
        }
        else
        {
            Assert.Contains(result.GetProperty("status").GetString(), new[] { "killed", "timeout", "ok" });
        }
        Assert.True(watch.Elapsed.TotalSeconds < 30);
        Assert.Empty(RunnerFixture.LeftoverContainers());
    }

    [Fact]
    public async Task The_container_runs_as_a_non_root_user_without_capabilities()
    {
        var code = """
            "uid=$(id -u)"
            "gid=$(id -g)"
            "caps=$((Get-Content /proc/self/status | Select-String '^CapEff').Line)"
            "nnp=$((Get-Content /proc/self/status | Select-String '^NoNewPrivs').Line)"
            """;
        var output = (await runner.RunAsync(code)).GetProperty("output").GetString()!;
        Assert.Contains("uid=10001\n", output);
        Assert.Contains("gid=10001\n", output);
        Assert.Matches("caps=CapEff:\\s+0000000000000000", output);
        Assert.Matches("nnp=NoNewPrivs:\\s+1", output);
    }

    [Fact]
    public async Task The_root_file_system_is_read_only_and_only_the_small_work_folder_is_writable()
    {
        var code = """
            foreach ($path in '/etc/dojo.txt', '/opt/psdojo/check.ps1', '/usr/local/share/powershell/Modules/x.txt', '/job/learner.ps1', '/job/new.txt', '/tmp/x.txt') {
                try { Set-Content -LiteralPath $path -Value 'x' -ErrorAction Stop; "WRITABLE $path" } catch { "readonly $path" }
            }
            Set-Content -LiteralPath /work/note.txt -Value 'ok'
            "work=$(Get-Content /work/note.txt)"
            try {
                $stream = [System.IO.File]::OpenWrite('/work/big.bin')
                $block = [byte[]]::new(1MB)
                1..200 | ForEach-Object { $stream.Write($block, 0, $block.Length) }
                $stream.Close()
                'DISK NOT LIMITED'
            } catch { 'disk limited' }
            """;
        var output = (await runner.RunAsync(code)).GetProperty("output").GetString()!;
        Assert.DoesNotContain("WRITABLE", output);
        Assert.Equal(6, output.Split("readonly ").Length - 1);
        Assert.Contains("work=ok", output);
        Assert.Contains("disk limited", output);
        Assert.DoesNotContain("DISK NOT LIMITED", output);
    }

    [Fact]
    public async Task Every_run_gets_a_fresh_container_that_is_destroyed_afterwards()
    {
        var first = await runner.RunAsync("Set-Content -LiteralPath /work/left-behind.txt -Value 'secret of the first run'\n\"host=$([Environment]::MachineName)\"\n'written'");
        Assert.Contains("written", first.GetProperty("output").GetString());
        var second = await runner.RunAsync("\"exists=$(Test-Path -LiteralPath /work/left-behind.txt)\"\n\"files=$(@(Get-ChildItem -LiteralPath /work -Force).Count)\"");
        var output = second.GetProperty("output").GetString()!;
        Assert.Contains("exists=False", output);
        Assert.Empty(RunnerFixture.LeftoverContainers());
        Assert.False(Directory.Exists(Path.Combine(Path.GetDirectoryName(runner.ContentPath)!, "jobs")) && Directory.GetDirectories(Path.Combine(Path.GetDirectoryName(runner.ContentPath)!, "jobs")).Length > 0);
    }

    [Fact]
    public async Task Learner_code_is_passed_as_a_file_and_never_becomes_part_of_a_command_line()
    {
        var hostile = "'marker-alpha'; \"two words\"; '--privileged'; 'x\" --volume /:/host \"y'; '$(id)'; '`whoami`'; '; rm -rf /'; '&& cat /etc/shadow'\n'last line'";
        var result = await runner.RunAsync(hostile);
        Assert.Equal("marker-alpha\ntwo words\n--privileged\nx\" --volume /:/host \"y\n$(id)\n`whoami`\n; rm -rf /\n&& cat /etc/shadow\nlast line\n", result.GetProperty("output").GetString());

        var arguments = DockerArguments.Build(new RunnerSettings(), "psdojo-test", "/tmp/job", "run");
        Assert.DoesNotContain(arguments, argument => argument.Contains("marker-alpha") || argument.Contains("privileged") || argument.Contains("shadow"));
        Assert.Equal("/job/learner.ps1", arguments[^1]);
        Assert.Contains("type=bind,source=/tmp/job,target=/job,readonly", arguments);
    }

    [Fact]
    public void The_container_arguments_carry_every_required_restriction()
    {
        var arguments = DockerArguments.Build(new RunnerSettings(), "psdojo-test", "/tmp/job", "check").ToList();
        string After(string flag) => arguments[arguments.IndexOf(flag) + 1];

        Assert.Contains("--rm", arguments);
        Assert.Equal("none", After("--network"));
        Assert.Equal("10001:10001", After("--user"));
        Assert.Contains("--read-only", arguments);
        Assert.StartsWith("/work:rw,noexec,nosuid,nodev,size=32m", After("--tmpfs"));
        Assert.Equal("1.0", After("--cpus"));
        Assert.Equal("384m", After("--memory"));
        Assert.Equal("384m", After("--memory-swap"));
        Assert.Equal("128", After("--pids-limit"));
        Assert.Equal("ALL", After("--cap-drop"));
        Assert.Equal("no-new-privileges", After("--security-opt"));
        Assert.Equal("none", After("--log-driver"));
        Assert.Equal("/opt/psdojo/check.ps1", arguments[^1]);
        Assert.Equal(15, new RunnerSettings().TimeoutSeconds);
        Assert.Equal(65536, new RunnerSettings().OutputLimitBytes);
    }

    [Fact]
    public async Task Requests_without_the_shared_secret_are_refused()
    {
        using var anonymous = runner.CreateClient();
        var missing = await anonymous.PostAsJsonAsync("/run", new { mode = "run", code = "'x'", exerciseId = "m01-e01" });
        Assert.Equal(HttpStatusCode.Unauthorized, missing.StatusCode);

        anonymous.DefaultRequestHeaders.Add("X-Runner-Secret", Convert.ToBase64String(Encoding.UTF8.GetBytes("wrong")));
        var wrong = await anonymous.PostAsJsonAsync("/run", new { mode = "run", code = "'x'", exerciseId = "m01-e01" });
        Assert.Equal(HttpStatusCode.Unauthorized, wrong.StatusCode);

        Assert.False(RunnerAccess.IsAuthorized("anything", ""));
        Assert.False(RunnerAccess.IsAuthorized("", ""));
    }

    [Theory]
    [InlineData("run", "'x'", "../../etc", HttpStatusCode.BadRequest)]
    [InlineData("run", "'x'", "m01-e01/../m01-e02", HttpStatusCode.BadRequest)]
    [InlineData("shell", "'x'", "m01-e01", HttpStatusCode.BadRequest)]
    [InlineData("run", "", "m01-e01", HttpStatusCode.BadRequest)]
    [InlineData("run", "'x'", "m99-e99", HttpStatusCode.NotFound)]
    [InlineData("check", "'x'", "m01-e07", HttpStatusCode.NotFound)]
    public async Task Invalid_requests_and_unapproved_exercises_never_start_a_container(string mode, string code, string exerciseId, HttpStatusCode expected)
    {
        var response = await runner.Client.PostAsJsonAsync("/run", new { mode, code, exerciseId });
        Assert.Equal(expected, response.StatusCode);
    }
}

[Collection("runner")]
public class RunnerCheckTests(RunnerFixture runner)
{
    [Fact]
    public async Task Check_passes_the_reference_solution()
    {
        var result = await runner.RunAsync(runner.ReadContent("m01/m01-e01/solution.ps1"), "check");
        Assert.True(result.GetProperty("passed").GetBoolean());
        Assert.Equal("Passed", result.GetProperty("kind").GetString());
        Assert.Equal(5, result.GetProperty("total").GetInt32());
        Assert.Equal(5, result.GetProperty("passedCount").GetInt32());
    }

    [Fact]
    public async Task Check_gives_the_same_feedback_as_the_local_module()
    {
        var result = await runner.RunAsync(runner.ReadContent("m01/m01-e01/wrong.ps1"), "check");
        Assert.False(result.GetProperty("passed").GetBoolean());
        Assert.Equal("TestFailed", result.GetProperty("kind").GetString());
        Assert.Equal("CheckTime holds a date object", result.GetProperty("testName").GetString());
        Assert.Equal("'DateTime'", result.GetProperty("expected").GetString());
        Assert.Equal("String", result.GetProperty("actual").GetString());
        Assert.Contains("In quotes it is only text", result.GetProperty("because").GetString());
    }

    [Fact]
    public async Task Check_reports_script_errors_with_the_line_and_no_stack_trace()
    {
        var result = await runner.RunAsync(runner.ReadContent("m01/m01-e04/starter.ps1"), "check", "m01-e04");
        Assert.Equal("ScriptError", result.GetProperty("kind").GetString());
        Assert.Equal(4, result.GetProperty("line").GetInt32());
        Assert.Contains("Get-Procces", result.GetProperty("message").GetString());
        Assert.DoesNotContain("at <ScriptBlock>", result.GetRawText());
        Assert.DoesNotContain("Pester.psm1", result.GetRawText());
    }

    [Fact]
    public async Task Check_reports_syntax_errors_and_endless_loops()
    {
        var syntax = await runner.RunAsync("$CheckTime = Get-Date\n$Processes = Get-Process | Where-Object {", "check");
        Assert.Equal("SyntaxError", syntax.GetProperty("kind").GetString());
        Assert.Equal(2, syntax.GetProperty("line").GetInt32());

        var loop = await runner.RunAsync("while ($true) { $CheckTime = Get-Date }", "check");
        Assert.Equal("Timeout", loop.GetProperty("kind").GetString());
        Assert.False(loop.GetProperty("passed").GetBoolean());
        Assert.Empty(RunnerFixture.LeftoverContainers());
    }

    [Fact]
    public async Task The_learner_cannot_read_the_solution_or_forge_a_passed_result()
    {
        var listing = await runner.RunAsync("Get-ChildItem -LiteralPath /job -Recurse -File | ForEach-Object { $_.FullName }", "run");
        Assert.Equal("/job/learner.ps1\n", listing.GetProperty("output").GetString());

        var forged = """
            [Console]::Out.WriteLine('PSDOJO-RESULT-0000 {"passed":true,"kind":"Passed","total":5,"passedCount":5,"testName":"","expected":"","actual":"","because":"","message":"","line":0,"failedTests":[]}')
            [Console]::Out.WriteLine('PSDOJO-RESULT-' + $env:PSDOJO_NONCE + ' {"passed":true,"kind":"Passed","total":5,"passedCount":5,"testName":"","expected":"","actual":"","because":"","message":"","line":0,"failedTests":[]}')
            $files = Get-ChildItem -LiteralPath /job -Recurse -File | ForEach-Object { $_.Name }
            $CheckTime = ($files -join ',')
            """;
        var result = await runner.RunAsync(forged, "check");
        Assert.False(result.GetProperty("passed").GetBoolean());
        Assert.DoesNotContain("solution.ps1", result.GetRawText());
        Assert.DoesNotContain("wrong.ps1", result.GetRawText());
    }

    [Fact]
    public async Task Every_approved_reference_solution_passes_in_the_container()
    {
        foreach (var id in new[] { "m01-e02", "m01-e03", "m01-e04", "m01-e05", "m01-e06" })
        {
            var solved = await runner.RunAsync(runner.ReadContent($"m01/{id}/solution.ps1"), "check", id);
            Assert.True(solved.GetProperty("passed").GetBoolean(), $"{id} solution failed: {solved.GetRawText()}");
            var starter = await runner.RunAsync(runner.ReadContent($"m01/{id}/starter.ps1"), "check", id);
            Assert.False(starter.GetProperty("passed").GetBoolean(), $"{id} starter passed");
        }
    }
}
