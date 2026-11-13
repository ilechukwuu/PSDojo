# Task

The helpdesk documentation lists example calls for a function. Before it is published you
check which of them work. The function:

```powershell
function Get-LogExtract {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Path,

        [ValidateSet('Error', 'Warning', 'Info')]
        [string]$Level = 'Error',

        [ValidateRange(1, 1000)]
        [int]$Last = 50
    )
    $Last
}
```

For calls 1 to 5 store `$true` if the body runs and `$false` if the call is rejected. Do
not run anything.

1. `Get-LogExtract -Path D:\Logs\app.log` in `$Result1`
2. `Get-LogExtract -Path D:\Logs\app.log -Level warning` in `$Result2`
3. `Get-LogExtract -Path D:\Logs\app.log -Level Debug` in `$Result3`
4. `Get-LogExtract -Path D:\Logs\app.log -Last 1000` in `$Result4`
5. `Get-LogExtract -Path D:\Logs\app.log -Lines 20` in `$Result5`
6. `Get-LogExtract -Path D:\Logs\app.log -Last 2.7` runs. Store what it returns in
   `$Result6`.
