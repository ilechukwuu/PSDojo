# Aufgabe

Ein Wiederholungszähler in einem Sync-Skript meldet immer null Wiederholungen, obwohl das Log
mehrere zeigt. Du liest das Skript und sagst vorher, was jede Variable enthält. Führe nichts
aus.

```powershell
$Retries = 0
$Site = 'Kiel'

function Add-Retry {
    $Retries = $Retries + 1
    $Retries
}

function Add-ScriptRetry {
    $script:Retries = $script:Retries + 1
}

function Get-Greeting {
    "Site $Site"
}

$First = Add-Retry
$Second = Add-Retry
$AfterLocal = $Retries

Add-ScriptRetry
$AfterScript = $Retries

if ($Retries -gt 0) { $Status = 'retried' }
```

1. Speichere den Wert von `$Second` in `$Result1`.
2. Speichere den Wert von `$AfterLocal` in `$Result2`.
3. Speichere den Wert von `$AfterScript` in `$Result3`.
4. Speichere die Ausgabe von `Get-Greeting` in `$Result4`.
5. Speichere den Wert von `$Status` nach der letzten Zeile in `$Result5`.
