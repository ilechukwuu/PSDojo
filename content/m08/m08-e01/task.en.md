# Task

During the morning check on application server APP-01 you sort the services into three
lists. Each service object has the properties `Name`, `Status` and `StartType`.

1. Store the services whose `Status` is `Stopped` in `$Stopped`.
2. Store the services whose `StartType` is not `Disabled` in `$NotDisabled`.
3. Store the services whose `Status` is `Running` in `$Running`.

Each line is `Get-Service` piped into `Where-Object` with a condition in braces.
