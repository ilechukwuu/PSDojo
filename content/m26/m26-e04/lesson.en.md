# Where the pieces belong

An advanced function has a fixed layout. Mistakes in it produce errors that point at the
wrong place, so it pays to know the layout by heart.

1. `function Name {`
2. `[CmdletBinding()]`, the attribute of the `param` block. It has to stand directly in
   front of `param`. Below the block it is a syntax error.
3. `param( ... )` with the parameters, separated by commas. In front of each parameter:
   its attributes, then its type.
4. The body.

**`ValidateSet` takes a list.** `[ValidateSet('Full', 'Log')]` has two allowed values.
`[ValidateSet('Full,Log')]` has one, the text `Full,Log` with a comma in it. Neither
`Full` nor `Log` is accepted.

**Status text is not a result.** A line such as `"Creating plan for $Name"` in the body is
output and lands in the result, in front of the real object. The caller suddenly gets
two things. Messages go to `Write-Verbose`.

## Example

```powershell
function Get-Quota {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Share,

        [ValidateSet('GB', 'TB')]
        [string]$Unit = 'GB'
    )

    Write-Verbose -Message "Reading quota of $Share"
    [pscustomobject]@{ Share = $Share; Unit = $Unit }
}
```
