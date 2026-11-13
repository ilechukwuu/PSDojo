# Module 26 in review

This quiz closes the module. It covers what you have used in the exercises before:

- `[CmdletBinding()]` directly above `param` gives a function the common parameters.
- `[Parameter(Mandatory)]` enforces a value.
- `Write-Verbose` for status messages, never bare text in the body.
- Validation attributes reject wrong input before the body runs.
- Binding converts first and validates afterwards.
- Unattended scripts run with `-NonInteractive`.

You pass with 80 percent. If you fail you can try again as often as you like. The feedback
tells you which questions were wrong, not what the right answer is.

## Example

```powershell
$Answer1 = 'b'
```

Each answer is the letter of one option, in quotes.
