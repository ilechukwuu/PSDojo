# Task

The script in your exercise file counts the services of APP-01 by status. It asks the server
twice. Rewrite it:

1. Call `Get-Service` exactly once, group by `Status` and store the groups in `$Groups`.
2. Read `$RunningCount` and `$StoppedCount` from `$Groups`.
3. `$Summary` stays as it is.

The three variables `$RunningCount`, `$StoppedCount` and `$Summary` must hold the same
values as now.
