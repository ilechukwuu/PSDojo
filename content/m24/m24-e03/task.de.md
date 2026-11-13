# Aufgabe

Ein Alarmskript meldet Volumes, die gar nicht knapp sind. Irgendwo zwischen der Definition
der Regel und ihrer Verwendung wird der Schwellwert geändert. Sage die Ergebnisse vorher.
Führe nichts aus.

```powershell
$Limit = 10
$IsLow = { param($Value) $Value -lt $Limit }

$A = & $IsLow 12

$Limit = 20
$B = & $IsLow 12

$Frozen = $IsLow.GetNewClosure()
$Limit = 5
$C = & $Frozen 12
$D = & $IsLow 12

$Ping = { Test-Connection -ComputerName FS-01 -Count 1 }
$Servers = & { 'FS-01'; 'FS-02' }
```

1. Speichere den Wert von `$A` in `$Result1`.
2. Speichere den Wert von `$B` in `$Result2`.
3. Speichere den Wert von `$C` in `$Result3`.
4. Speichere den Wert von `$D` in `$Result4`.
5. Wie oft wurde FS-01 von diesem Skript angepingt? Speichere die Zahl in `$Result5`.
6. Speichere den Wert von `$Servers.Count` in `$Result6`.
