# Functions

A function is a script block with a name. Once defined, it is called like a cmdlet.

`function Get-FreePercent { ... }`

**The name** follows the pattern of the cmdlets: an approved verb, a hyphen, a singular
noun. `Get-Verb` lists the approved verbs. `Get-` returns something, `Set-` changes
something, `Test-` answers with true or false. Whoever reads the name knows what to
expect.

**The parameters** stand in a `param` block at the start, as in a script: name, optional
type, optional default.

**The result** is whatever the function outputs. A value that stands alone on a line is
output. There is no need for a special keyword. `Write-Host` only paints text on the
screen. Nothing of it arrives at the caller, so a function that should return something
never uses it for the result.

The caller passes values by name, `-FreeGB 18`, or by position in the order of the `param`
block.

## Example

```powershell
function Get-UsedGB {
    param(
        [double]$SizeGB,
        [double]$FreeGB
    )

    [math]::Round($SizeGB - $FreeGB, 1)
}

$Used = Get-UsedGB -SizeGB 240 -FreeGB 18.4
```
