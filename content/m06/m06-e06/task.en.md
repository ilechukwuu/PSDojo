# Task

The script in your exercise file collects the names and the total memory of the processes
of a line-of-business application on TS-03. It picks every process by its position. That
works today, with exactly three processes.

Rewrite it so that it works for any number of processes:

1. `$Names` is read from `$All` in one step.
2. `$TotalMemory` adds up `WorkingSet64` of all processes with `Measure-Object -Sum`.
3. No `[0]`, `[1]` or `[2]` remains, and no variable other than `$All`, `$Names` and
   `$TotalMemory` is assigned.
