# Two ways to run a script

**Calling.** `& $Path` or simply `.\settings.ps1` runs the script in a new scope. Its
output comes back to you. Its variables and functions are gone when it ends. This is the
normal way to run a tool.

The call operator `&` is needed when the path is in a variable or contains spaces. A text
in quotes alone would just be output as text.

**Dot-sourcing.** A dot, a space, then the path: `. $Path`. The script runs in *your*
scope, as if its lines stood in your file. Its variables and functions remain afterwards.
This is how a script loads a file with shared settings or helper functions.

Dot-sourcing also returns the output of the script. Assign it to `$null` if you only want
the definitions.

Do not confuse the dot of dot-sourcing with the `.\` of a relative path. `. .\settings.ps1`
contains both.

`$PSScriptRoot` holds the folder of the running script. Use it to find files that lie next
to your script, whatever the current folder is.

## Example

```powershell
$Helpers = Join-Path -Path $PSScriptRoot -ChildPath 'Helpers.ps1'
. $Helpers

$Report = & (Join-Path -Path $PSScriptRoot -ChildPath 'Get-DiskReport.ps1') -ComputerName FS-01
```
