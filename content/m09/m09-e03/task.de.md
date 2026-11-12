# Aufgabe

Auf dem Druckserver PRN-01 liefert `Get-Service` diese sieben Dienste:

```powershell
Name          Status  StartType
----          ------  ---------
Spooler       Running Automatic
LPDSVC        Stopped Manual
PrintNotify   Running Manual
WinRM         Running Automatic
BITS          Stopped Manual
W32Time       Stopped Manual
RemoteRegistry Stopped Disabled
```

Sage die Ergebnisse vorher, ohne etwas auszuführen.

1. `Get-Service | Group-Object -Property StartType | Measure-Object` Wie viele Gruppen
   werden gezählt? Speichere die Zahl in `$GroupCount`.
2. `Get-Service | Group-Object -Property Status | Sort-Object -Property Count -Descending | Select-Object -First 1 -ExpandProperty Name`
   Welcher Text kommt heraus? Speichere ihn in `$LargestGroup`.
3. `(Get-Service | Sort-Object -Property StartType, Name | Select-Object -First 1).Name`
   Welcher Name kommt heraus? Speichere ihn in `$FirstName`.
4. `Get-Service | Select-Object -ExpandProperty Status | Sort-Object -Unique | Measure-Object`
   Welche Zahl steht in Count? Speichere sie in `$UniqueCount`.
