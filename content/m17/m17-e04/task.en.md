# Task

A deployment script keeps the default settings for new servers in a hashtable and derives
the settings for one server from them. Afterwards the defaults are wrong. Predict what the
lines return. Do not run anything.

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

1. Store what line 6 returns in `$Result1`.
2. Store what line 7 returns in `$Result2`.
3. Store what line 8 returns in `$Result3`. For nothing, store `$null`.
4. Store what line 10 returns in `$Result4`.
