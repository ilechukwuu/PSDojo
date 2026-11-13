# Task

The disk check of your team exists in four copies, one per file server, each with a
different name and threshold typed into it. You write the one version that takes both as
parameters.

1. Write a `param` block with three parameters:
   - `$ComputerName`, a text, default `FS-01`
   - `$WarnPercent`, a whole number, default `20`
   - `$Detailed`, a switch
2. Below it store `detailed` in `$Mode` if the switch was given, otherwise `short`.

The dojo calls your script with and without arguments.
