# Task

The script in your exercise file is part of the memory monitoring for TS-03. It contains
three pipelines and each one is broken in a different way.

Repair them:

- `$Sorted` must hold all processes sorted by name.
- `$TopTwo` must hold the two processes with the highest `WorkingSet64`, largest first.
- `$Smallest` must hold the one process with the lowest `WorkingSet64`. This pipeline must
  also run in Windows PowerShell 5.1.

Keep the cmdlets and their parameters. Change only how they are connected.
