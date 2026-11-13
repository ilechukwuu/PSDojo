# Aufgabe

Die Helpdesk-Dokumentation listet Beispielaufrufe einer Funktion. Bevor sie veröffentlicht
wird, prüfst du, welche davon funktionieren. Die Funktion:

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

Speichere für die Aufrufe 1 bis 5 `$true`, wenn der Rumpf läuft, und `$false`, wenn der
Aufruf abgelehnt wird. Führe nichts aus.

1. `Get-LogExtract -Path D:\Logs\app.log` in `$Result1`
2. `Get-LogExtract -Path D:\Logs\app.log -Level warning` in `$Result2`
3. `Get-LogExtract -Path D:\Logs\app.log -Level Debug` in `$Result3`
4. `Get-LogExtract -Path D:\Logs\app.log -Last 1000` in `$Result4`
5. `Get-LogExtract -Path D:\Logs\app.log -Lines 20` in `$Result5`
6. `Get-LogExtract -Path D:\Logs\app.log -Last 2.7` läuft. Speichere, was er liefert, in
   `$Result6`.
