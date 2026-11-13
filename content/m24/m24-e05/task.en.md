# Task

The health check in your exercise file decides with an `if` chain whether a measured value
is healthy. Every new kind of check makes the chain longer. Rewrite it as a table.

1. Store a hashtable in `$Checks` with the keys `Disk`, `Memory` and `Latency`. Each value
   is a script block with a parameter `$Value` that returns `$true` or `$false` by the same
   rule as before.
2. Look up the block for `$CheckName`, invoke it with `$Value` and store the result in
   `$Healthy`.
3. No `if` may remain.

Leave the line with `param` as it is.
