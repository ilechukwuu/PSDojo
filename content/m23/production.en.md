# What goes wrong in production

A script that reports the free space of the file servers works every time the administrator
runs it at their desk. As a scheduled task it writes an empty report every night.

The script reads `$Servers`, and nothing in it ever sets that variable. The administrator
had filled it weeks ago in their console, later in their profile, and the script quietly
picked it up from there. The scheduled task runs under a service account with no profile,
so the variable is empty and the loop runs zero times. No error, exit code 0.

A script may only depend on what comes in through its `param` block or what it creates
itself. Test it the way it will run: in a new console started with
`powershell.exe -NoProfile -File .\script.ps1`.
