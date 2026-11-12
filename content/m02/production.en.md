# What goes wrong in production

A script is developed in the editor over an afternoon. It runs fine there, so it is registered
as a scheduled task. At night it fails with an empty variable.

The editor keeps one session open. Every variable you ever set by hand or by an earlier
version of the script is still there, so the script quietly uses values that it never sets
itself:

```powershell
$Report = "$LogFolder\report.csv"
```

`$LogFolder` was typed into the console pane hours ago. In a fresh session it is empty.

Before you hand a script over, run it once in a new console window with nothing loaded.
