# Task

The script in your exercise file takes a line of the monitoring log apart with `Split` and
fixed positions. It works for the default line and returns nonsense for lines with more
words. Rewrite it.

1. Use one `-match` with the named groups `Date`, `Level`, `Server` and `Percent`.
2. Fill `$Date`, `$Level`, `$Server` and `$Percent` from `$Matches`. `$Percent` is a whole
   number.
3. No `Split` and no index with a number may remain.

For the default line the four variables must hold the same values as now. Leave the line
with `param` as it is.
