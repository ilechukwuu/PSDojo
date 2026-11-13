# What goes wrong in production

A cleanup script empties the staging folder of a deployment every night:

```powershell
Remove-Item -Path "$StagingDir\*" -Recurse -Force
```

One day the line that fills `$StagingDir` is changed and the variable name gets a typo. The
variable is now empty, the path becomes `\*`, and the script deletes everything it is
allowed to delete on the current drive. `-Force` makes sure hidden and read-only files go
too.

Never delete along a path you have not checked. Test that the variable is not empty and
that the folder exists with `Test-Path`, build the path with `Join-Path`, and run a new
cleanup script with `-WhatIf` until its output shows exactly the files you mean.
