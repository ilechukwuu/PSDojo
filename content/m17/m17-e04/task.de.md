# Aufgabe

Ein Deployment-Skript hält die Standardeinstellungen für neue Server in einer Hashtable und
leitet daraus die Einstellungen für einen Server ab. Danach stimmen die Standardwerte nicht
mehr. Sage vorher, was die Zeilen liefern. Führe nichts aus.

```powershell
$Defaults = @{ Site = 'Kiel'; Port = 445 }
$ForFS02 = $Defaults
$ForFS02.Site = 'Hamburg'
$ForFS02['Owner'] = 'Team Elbe'

$Defaults.Site
$Defaults.Count
$Defaults['Role']
$Row = [pscustomobject]@{ Server = 'FS-02'; Site = 'Hamburg'; Port = 445 }
$Row.PSObject.Properties.Name -join ','
```

1. Speichere, was Zeile 6 liefert, in `$Result1`.
2. Speichere, was Zeile 7 liefert, in `$Result2`.
3. Speichere, was Zeile 8 liefert, in `$Result3`. Für nichts speichere `$null`.
4. Speichere, was Zeile 10 liefert, in `$Result4`.
