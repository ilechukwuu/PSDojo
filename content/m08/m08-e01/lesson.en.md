# Where-Object

`Where-Object` is the filter of the pipeline. It looks at every object that arrives and lets
it through only if a condition is true.

The condition goes in curly braces. Inside them `$_` stands for the object that is being
looked at right now. You read a property of it and compare:

- `-eq` equal, `-ne` not equal
- `-gt` greater than, `-ge` greater or equal
- `-lt` less than, `-le` less or equal

PowerShell does not use `=`, `<` or `>` for comparing. `=` assigns a value, and `>` writes
to a file.

Text on the right side of a comparison goes in quotes. Comparing text ignores upper and
lower case.

There is a shorter form for a single comparison, `Where-Object Status -eq 'Running'`. The
form with braces can do everything, so learn that one first.

## Example

```powershell
Get-Service | Where-Object { $_.Status -eq 'Stopped' }
Get-Process | Where-Object { $_.WorkingSet64 -gt 500MB }
```

Line 1 returns the stopped services. Line 2 returns the processes that use more than
500 MB. `MB` and `GB` are understood as units.
