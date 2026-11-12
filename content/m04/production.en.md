# What goes wrong in production

A cleanup script starts with `Set-Location D:\Temp\Scans` and then deletes with a relative
path:

```powershell
Set-Location -Path D:\Temp\Scans
Remove-Item -Path * -Recurse -Force
```

One night drive D: is offline. `Set-Location` fails, the script keeps running, and the
second line runs wherever the session happens to be. As a scheduled task that is
`C:\Windows\System32`.

Never let a destructive command depend on the current location. Give it a full path, and
make sure the script stops when a step before it fails.
