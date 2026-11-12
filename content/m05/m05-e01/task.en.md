# Task

Terminal server TS-03 is slow. For the ticket you need three facts about its processes.

1. Store all processes sorted by `Name` in `$ByName`.
2. Store the two processes with the highest `WorkingSet64` in `$TopTwo`. Sort descending,
   then take the first two.
3. Store the number of processes in `$ProcessCount`.

Each line is one pipeline that starts with `Get-Process`.
