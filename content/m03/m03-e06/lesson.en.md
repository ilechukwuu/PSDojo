# Parameter details

The syntax line tells you how to call a command. For one parameter, `Get-Help -Parameter`
tells you the rest in a small table:

- **Required?** true means the command does not run without a value. If you leave it out,
  PowerShell stops and asks for it, which hangs an unattended script.
- **Position?** A number means the value can be given without the name, at that position,
  counting from 0. `Named` means the name must be written.
- **Default value** is what the parameter uses when you say nothing.
- **Accept pipeline input?** says whether the parameter takes values from the pipeline.
  You need that from module 5 on.
- **Accept wildcard characters?** true means `*` is understood in the value. Never assume
  it, many parameters take a value literally.

## Example

```powershell
Get-Help -Name Stop-Process -Parameter Id

-Id <int[]>
    Required?                    true
    Position?                    0
    Accept pipeline input?       true (ByPropertyName)
    Accept wildcard characters?  false
```

`-Id` must be given, may be given by position, takes several values, and `*` means nothing
to it.
