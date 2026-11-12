# From error to help

Most parameter errors come from guessing. A name sounds plausible, PowerShell answers that
a parameter cannot be found that matches it, and the script stops.

Do not guess a second time. Ask:

- `Get-Command -Name Get-Alias -Syntax` prints every parameter in one line.
- `Get-Help -Name Get-Alias -Parameter *` lists each parameter with its details.
- In the editor, type the hyphen and press Tab or Ctrl+Space to see the real names.

Parameter names follow conventions, which makes good guesses possible: `-Name`, `-Path`,
`-Filter`, `-Force`, `-Recurse` mean the same wherever they appear. But a convention is not
a guarantee, and similar cmdlets sometimes use different names for the same idea.

PowerShell accepts a shortened name as long as it is unambiguous, so `-Rec` works for
`-Recurse`. That is fine while typing in the console. In a script write the full name.

## Example

```powershell
Get-Alias -Cmdlet Get-ChildItem
# A parameter cannot be found that matches parameter name 'Cmdlet'.

Get-Command -Name Get-Alias -Syntax
Get-Alias -Definition Get-ChildItem
```

The syntax shows that the parameter is called `-Definition`.
