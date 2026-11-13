# The order inside a script

PowerShell reads a script from top to bottom and runs each statement when it reaches it.
Three rules follow from that.

**`param` comes first.** Only comments and `#Requires` lines may stand above the `param`
block. A statement in front of it is a syntax error, and the script does not run at all.

**Define before use.** A `function` statement creates the function at the moment it is
run. A call further up in the file fails with "The term ... is not recognized". The usual
layout is therefore: `param` block, then all functions, then the main part that calls
them.

**A function counts in its own scope.** A counter that a function is meant to increase
needs the `$script:` prefix, or better, the function returns a value and the caller
counts.

The last output of a script can be an object that sums up the result. The caller receives
it and can work with its properties.

## Example

```powershell
param([string[]]$ComputerName)

function Test-Name {
    param($Name)
    $script:Checked = $script:Checked + 1
    $Name -like 'FS-*'
}

$Checked = 0
$FileServers = $ComputerName | Where-Object { Test-Name -Name $_ }

[pscustomobject]@{ Checked = $Checked; FileServers = $FileServers }
```
