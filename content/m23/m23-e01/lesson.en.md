# Scripts and parameters

A script is a text file with the extension `.ps1`. You run it with its path:
`.\Get-DiskReport.ps1`. The `.\` is required. PowerShell does not run scripts from the
current folder by name alone.

A script that should be reusable takes its input through a **`param` block**. It has to be
the first statement in the file. Only comments may stand above it.

Each parameter is a variable and can have:

- a **type** in square brackets in front. PowerShell converts the input, so `'15'` becomes
  the number 15, and rejects what cannot be converted.
- a **default value** after an equals sign, used when the caller passes nothing.

A parameter of the type `[switch]` is an on/off flag. It takes no value. It is true when
the caller writes it and false otherwise. Never give a switch a default value.

The caller uses the names like those of a cmdlet:
`.\Get-DiskReport.ps1 -ComputerName FS-02 -Detailed`

## Example

```powershell
param(
    [string]$ComputerName = 'FS-01',
    [int]$WarnPercent = 20,
    [switch]$Detailed
)

if ($Detailed) {
    "Checking $ComputerName in detail, threshold $WarnPercent"
}
```
