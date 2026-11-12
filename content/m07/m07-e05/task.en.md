# Task

The script in your exercise file checks four processes on TS-03 one after the other and
glues the results together. Rewrite it so that `Get-Process` is called exactly once.

1. Keep the line that defines `$Names`.
2. Assign `$Found` with a single call of `Get-Process` that receives the whole list.
3. Remove the helper variables `$p1` to `$p4`.

`$Found` must hold the same four processes as now.
