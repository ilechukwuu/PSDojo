# What goes wrong in production

An admin needs to clean up old log files and finds a command in an old ticket:

```powershell
Remove-Item -Path D:\Logs -Recurse -Force
```

He runs it without reading the help. `-Recurse` removes the folder with everything in it,
`-Force` includes hidden and read-only files, and nothing asks for confirmation. The folder
that the backup job writes to is gone as well.

Thirty seconds with `Get-Help Remove-Item -Parameter Recurse` and a first run with `-WhatIf`
would have shown exactly what was about to happen. Read the help for every parameter you did
not choose yourself.
