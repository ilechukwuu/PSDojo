using System.Globalization;

namespace PSDojo.Runner;

/// <summary>
/// Builds the argument list for one container. Learner code never appears here. It reaches
/// the container only as the file /job/learner.ps1 on a read-only mount.
/// </summary>
public static class DockerArguments
{
    public const string ContainerUser = "10001:10001";

    public static IReadOnlyList<string> Build(RunnerSettings settings, string containerName, string jobFolder, string mode)
    {
        var tmpfs = string.Create(CultureInfo.InvariantCulture, $"/work:rw,noexec,nosuid,nodev,size={settings.TmpfsMb}m,uid=10001,gid=10001,mode=0700");
        var memory = string.Create(CultureInfo.InvariantCulture, $"{settings.MemoryMb}m");
        var arguments = new List<string>
        {
            "run",
            "--rm",
            "--name", containerName,
            "--network", "none",
            "--user", ContainerUser,
            "--read-only",
            "--tmpfs", tmpfs,
            "--cpus", settings.Cpus,
            "--memory", memory,
            "--memory-swap", memory,
            "--pids-limit", settings.PidsLimit.ToString(CultureInfo.InvariantCulture),
            "--cap-drop", "ALL",
            "--security-opt", "no-new-privileges",
            "--ulimit", "nofile=1024:1024",
            "--ulimit", "core=0",
            "--log-driver", "none",
            "--ipc", "none",
            "--hostname", "dojo",
            "--env", "HOME=/work",
            "--env", "TMPDIR=/work",
            "--env", "DOTNET_gcHeapHardLimitPercent=60",
            "--mount", $"type=bind,source={jobFolder},target=/job,readonly",
            "--workdir", "/work",
        };
        if (mode == "check")
        {
            arguments.Add("--interactive");
        }
        arguments.Add(settings.Image);
        arguments.AddRange(["pwsh", "-NoLogo", "-NoProfile", "-NonInteractive", "-File"]);
        arguments.Add(mode == "check" ? "/opt/psdojo/check.ps1" : "/job/learner.ps1");
        return arguments;
    }
}
