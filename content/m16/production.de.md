# Was in der Produktion schiefgeht

Ein Skript startet die Anwendungspools neu, die eine Abfrage liefert, und protokolliert, wie
viele es waren:

```powershell
$Pools = Get-IISAppPool | Where-Object { $_.State -eq 'Stopped' }
Write-Output "Restarting $($Pools.Count) pools, first: $($Pools[0].Name)"
```

Auf dem Testserver waren drei Pools gestoppt, und alles funktionierte. In der Produktion ist
genau einer gestoppt. Die Abfrage liefert jetzt ein einzelnes Objekt, keine Liste. In Windows
PowerShell 5.1 ist `Count` mancher Einzelobjekte leer, und bei einem einzelnen Text liefert
`[0]` den ersten Buchstaben. Im Log steht "Restarting  pools".

Ein Befehl liefert je nach Datenlage nichts, ein Objekt oder eine Liste. Braucht dein Code
eine Liste, mach eine daraus: `$Pools = @(...)`.
