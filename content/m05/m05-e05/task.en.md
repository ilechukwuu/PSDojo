# Task

The script in your exercise file finds the three largest processes on TS-03 and counts
them. It works, but it drags four throwaway variables along.

Rewrite it:

1. `$Report` is assigned by a single pipeline that starts with `Get-Process`.
2. `$ReportCount` is calculated from `$Report`.
3. No other variable is assigned. `$a`, `$b`, `$c` and `$d` disappear.

`$Report` and `$ReportCount` must hold exactly what they hold now.
