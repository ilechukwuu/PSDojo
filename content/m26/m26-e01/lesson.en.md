# Advanced functions

One attribute in front of the `param` block changes what a function is:

`[CmdletBinding()]`

With it the function behaves like a compiled cmdlet. It gets the **common parameters**
without any code of yours: `-Verbose`, `-ErrorAction`, `-ErrorVariable`, `-WarningAction`
and more. It also becomes strict: an argument that fits no parameter is an error instead
of disappearing silently in `$args`.

**Mandatory parameters.** `[Parameter(Mandatory)]` in front of a parameter means the
function cannot run without it. Do not give a mandatory parameter a default value. It
would never be used.

**Status messages.** What the function is doing right now does not belong in its result.
`Write-Verbose` writes to a separate stream that is hidden by default. The caller switches
it on with `-Verbose`. That is the correct place for "Connecting to FS-01".

Attributes stack in front of a parameter, each in its own square brackets, then the type,
then the name.

## Example

```powershell
function Get-PrintQueue {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ComputerName,

        [string]$Queue = 'Default'
    )

    Write-Verbose -Message "Reading queue $Queue on $ComputerName"
    [pscustomobject]@{ ComputerName = $ComputerName; Queue = $Queue }
}
```
