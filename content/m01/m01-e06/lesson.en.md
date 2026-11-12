# Aliases

An alias is a second, shorter name for a cmdlet. `gps` runs `Get-Process`, `?` runs
`Where-Object`, `%` runs `ForEach-Object` and `select` runs `Select-Object`.

In the console aliases save typing, and that is what they are for. In a script they cost
more than they save:

- The next person has to decode every abbreviation before they can judge what the script
  does.
- Not every alias exists everywhere. `ls`, `cat` and `sort` are aliases on Windows. On Linux
  and macOS those names start the native programs instead, with different results.

So the rule is simple: type what you like in the console, write full cmdlet names in
anything you save.

`Get-Alias -Name` tells you which cmdlet is behind an alias.

## Example

```powershell
Get-Alias -Name gps

gps | ? { $_.Name -eq 'spoolsv' }

Get-Process | Where-Object { $_.Name -eq 'spoolsv' }
```

The first line resolves the alias. The second and third lines do exactly the same thing.
Only the third belongs in a script.
