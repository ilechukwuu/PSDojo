# Aufgabe

Ein Kollege, der aus einer anderen Programmiersprache kommt, hat Hilfsfunktionen für das
Inventar geschrieben. Ihre Ergebnisse sind "manchmal seltsam". Sage vorher, was zurückkommt.
Führe nichts aus.

```powershell
function Get-ServerCount {
    $List = New-Object -TypeName System.Collections.ArrayList
    $List.Add('FS-01')
    $List.Add('FS-02')
    return $List.Count
}

function Get-FirstFileServer {
    param($Names)
    foreach ($Name in $Names) {
        if ($Name -like 'FS-*') { return $Name }
    }
    'none'
}

function Join-Name {
    param($Site, $Server)
    "$Site|$Server"
}
```

1. `@(Get-ServerCount).Count` Speichere die Zahl in `$Result1`.
2. `(Get-ServerCount)[2]` Speichere den Wert in `$Result2`.
3. `Get-FirstFileServer -Names 'PRN-01', 'FS-02', 'FS-03'` Speichere das Ergebnis in
   `$Result3`.
4. `Join-Name -Site 'Kiel' -Server 'FS-01'` Speichere den Text in `$Result4`.
5. `Join-Name('Kiel', 'FS-01')` Speichere den Text in `$Result5`.
