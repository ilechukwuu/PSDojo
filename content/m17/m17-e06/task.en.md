# Task

The line in your exercise file searches the log folder of APP-01. It has five parameters
and runs far off the screen. Rewrite it with splatting.

1. Create a hashtable named `$LogSearch` with the five parameters, one per line.
2. Call `Get-ChildItem` with `@LogSearch` and nothing else, and store the result in `$Logs`.

`$Logs` must hold the same files as now. Leave the line with `param` as it is.
