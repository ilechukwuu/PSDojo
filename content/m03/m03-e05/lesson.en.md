# Positional and shortened parameters

PowerShell lets you type less in two ways.

**Positional.** `Get-ChildItem D:\Logs *.log` passes two values without names. PowerShell
assigns them by position: the first to `-Path`, the second to `-Filter`. You only know that
from the syntax, where the positional parameters are the ones with brackets around the
name, in order.

**Shortened.** `-Rec` is accepted for `-Recurse` and `-F` for `-Format`, as long as only
one parameter starts that way.

Both are fine in the console. In a script they are traps: the reader has to know the
positions by heart, and a shortened name can become ambiguous when a newer version adds a
parameter. Then a script that ran for years suddenly fails.

So in scripts write every parameter name, in full. The help gives you the names.

## Example

```powershell
Get-Command -Name Get-ChildItem -Syntax

Get-ChildItem D:\Logs *.log -Rec
Get-ChildItem -Path D:\Logs -Filter *.log -Recurse
```

The last two lines do the same. Only the last one can be understood without looking
anything up.
