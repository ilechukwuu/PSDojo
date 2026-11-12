# Task

Monitoring exports two watch lists for terminal server TS-03. The first lines of your
exercise file hold them as objects, the way `Import-Csv` would return them. Leave those
lines as they are.

1. Pipe `$WatchList` into `Get-Process` and store the result in `$Running`. The column is
   called `Name`.
2. Pipe `$LegacyList` into `Get-Process` and store the result in `$Legacy`. Its column is
   called `ProcessName`, which is an alias of the parameter `-Name`.
3. Pipe `$AliasList` into `New-Alias`. Each row has the columns `Name` and `Value`, and
   both bind. Afterwards the aliases `procs` and `items` exist.
