# No globals

`$global:` variables look like an easy way to configure a script: set them at the top,
use them everywhere. They have three costs.

- **They outlive the script.** After the run they stay in the session. The next script that
  uses the same name starts with your leftover value.
- **They hide the interface.** Nobody can see from the outside what the script needs. To
  run it for another folder you have to edit the file.
- **They cannot be tested.** Every test has to prepare and clean up the session.

A `param` block solves all three. The values that used to be typed into the file become
the **defaults**, so the script behaves as before when called without arguments. Whoever
needs something else passes it:

`.\Get-OldReport.ps1 -Path E:\Archive -Days 90`

Give each parameter a type. Then `-Days abc` is rejected at the call with a clear message,
instead of failing somewhere in the middle.

Variables the script only needs internally are plain variables without any prefix. They
disappear when the script ends.

## Example

```powershell
param(
    [string]$Path = 'D:\Reports',
    [int]$Days = 30
)

$Limit = (Get-Date).AddDays(-$Days)
Get-ChildItem -Path $Path -File | Where-Object { $_.LastWriteTime -lt $Limit }
```
