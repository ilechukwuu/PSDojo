# Eigene Objekte

Befehle liefern Objekte mit Eigenschaften, und alles in PowerShell ist dafür gebaut, damit
zu arbeiten: filtern, sortieren, exportieren. Erzeugt dein Skript eigene Ergebnisse, sollte
es dieselbe Art von Ding liefern.

`[pscustomobject]` vor einer Hashtable macht aus den Paaren Eigenschaften:

`[pscustomobject]@{ Server = 'FS-02'; FreeGB = 75 }`

Die Unterschiede zur einfachen Hashtable sind wichtig:

- Die Eigenschaften behalten die Reihenfolge, in der du sie geschrieben hast. Diese
  Reihenfolge wird zur Spaltenreihenfolge einer Tabelle oder CSV-Datei.
- Jedes Pipeline-Cmdlet versteht das Objekt. `Where-Object`, `Sort-Object`, `Export-Csv` und
  `Format-Table` sehen `Server` und `FreeGB`.
- Mehrere solche Objekte in einem Array bilden eine Tabelle, wie das Ergebnis jedes Befehls.

Nimm eine Hashtable zum Nachschlagen. Nimm ein eigenes Objekt für eine Datenzeile.

## Beispiel

```powershell
$Rows = @(
    [pscustomobject]@{ Server = 'FS-01'; FreeGB = 120 }
    [pscustomobject]@{ Server = 'FS-02'; FreeGB = 8 }
)
$Rows | Where-Object { $_.FreeGB -lt 20 }
```

Die letzte Zeile liefert die Zeile für FS-02, als Objekt.
