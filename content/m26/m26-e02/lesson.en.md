# Validation attributes

A function should not start working with input it cannot handle. Validation attributes
check a value at the moment it is bound to the parameter. If the check fails, the caller
gets an error that names the parameter and the rule, and not a single line of your body
has run.

The ones you need most:

- `[ValidateSet('Full', 'Log')]` allows only the listed values. As a bonus the console
  offers them with the Tab key. The comparison ignores case.
- `[ValidateRange(1, 90)]` allows numbers from 1 to 90, both included.
- `[ValidatePattern('^FS-\d{2}$')]` demands a match of the regular expression.
- `[ValidateNotNullOrEmpty()]` rejects `$null`, an empty text and an empty list.
- `[ValidateLength(1, 15)]` limits the length of a text.
- `[ValidateScript({ Test-Path -Path $_ })]` runs your own check. `$_` is the value.

Every rule you express as an attribute is one `if` with a hand-written error message that
you do not have to write, test and keep correct.

## Example

```powershell
function Get-LogExtract {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Path,

        [ValidateSet('Error', 'Warning', 'Info')]
        [string]$Level = 'Error',

        [ValidateRange(1, 1000)]
        [int]$Last = 50
    )
}
```
