# Skripte und Parameter

Ein Skript ist eine Textdatei mit der Endung `.ps1`. Du startest es mit seinem Pfad:
`.\Get-DiskReport.ps1`. Das `.\` ist Pflicht. PowerShell startet Skripte aus dem aktuellen
Ordner nicht allein über den Namen.

Ein Skript, das wiederverwendbar sein soll, nimmt seine Eingaben über einen
**`param`-Block**. Er muss die erste Anweisung in der Datei sein. Darüber dürfen nur
Kommentare stehen.

Jeder Parameter ist eine Variable und kann haben:

- einen **Typ** in eckigen Klammern davor. PowerShell wandelt die Eingabe um, aus `'15'` wird
  die Zahl 15, und lehnt ab, was sich nicht umwandeln lässt.
- einen **Standardwert** nach einem Gleichheitszeichen, der gilt, wenn der Aufrufer nichts
  übergibt.

Ein Parameter vom Typ `[switch]` ist ein Ein/Aus-Schalter. Er nimmt keinen Wert. Er ist wahr,
wenn der Aufrufer ihn schreibt, sonst falsch. Gib einem Schalter nie einen Standardwert.

Der Aufrufer nutzt die Namen wie bei einem Cmdlet:
`.\Get-DiskReport.ps1 -ComputerName FS-02 -Detailed`

## Beispiel

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
