# Return objects, not text

A function that returns the text `D: is low (12 %)` has done its caller a disservice. To
sort by the percentage or to filter for low volumes, the caller would have to cut the
text apart again.

A good function returns an **object** with one property per fact. Build it with
`[pscustomobject]@{ ... }` as the last statement. The caller can then do everything the
pipeline offers: `Where-Object`, `Sort-Object`, `Export-Csv`, `ConvertTo-Json`. How the
result looks on the screen is decided by whoever calls the function, not by the function.

**Optional parameters.** A parameter with a default value can be left out by the caller.
Use this for settings that have a sensible usual value, such as a threshold.

Keep names consistent with the cmdlets where you can: `Name`, `ComputerName`, `Path`.
People guess those without reading your code.

## Example

```powershell
function Get-CertificateState {
    param(
        [string]$Subject,
        [int]$DaysLeft,
        [int]$WarnDays = 30
    )

    [pscustomobject]@{
        Subject  = $Subject
        DaysLeft = $DaysLeft
        Expiring = $DaysLeft -lt $WarnDays
    }
}
```
