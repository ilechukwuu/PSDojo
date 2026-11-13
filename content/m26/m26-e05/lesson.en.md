# Declare, don't check

Functions written before their author knew validation attributes start with a wall of
`if` statements: is the name empty, is the number in range, is the mode one of the allowed
words. Each one throws an error with a text someone typed by hand.

Compare what each style gives you.

**Hand-written checks**

- run after the function has started
- are invisible from outside. `Get-Help` and `Get-Command` know nothing about them
- have error texts that drift away from the code when a limit is changed

**Attributes**

- run before the body
- are visible: `Get-Help` shows the allowed values, Tab completion offers them
- produce consistent error messages that name parameter, value and rule

The rewrite is mechanical. An "is it empty" check becomes `[Parameter(Mandatory)]`. A
"between" check becomes `[ValidateRange()]`. A "one of" check becomes `[ValidateSet()]`.
What remains in the body is the purpose of the function.

## Example

```powershell
function Get-ArchivePlan {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Share,

        [ValidateRange(30, 3650)]
        [int]$OlderThanDays = 365
    )

    [pscustomobject]@{ Share = $Share; OlderThanDays = $OlderThanDays }
}
```
