# Task

The function in your exercise file is meant to describe a restore job. It does not load,
and once it loads it rejects valid input and returns too much. It has three mistakes. Fix
them.

When it works:

- The file loads without a syntax error.
- `Get-RestoreJob -ComputerName FS-01 -Source Tape` is accepted, as are `Disk` and `Cloud`.
- The function returns exactly one object. The text `Preparing restore for <name>` appears
  only with `-Verbose`.
