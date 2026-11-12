# Der aktuelle Ort

Jede Sitzung hat einen aktuellen Ort, an dem relative Pfade beginnen. `Get-Location` zeigt
ihn, `Set-Location` ändert ihn. `cd` ist ein Alias für `Set-Location`.

In der Konsole bewegst du dich ständig. Ein Skript sollte das nicht, aus drei Gründen:

- Scheitert `Set-Location`, laufen die folgenden Befehle am falschen Ort.
- Das Skript hinterlässt die Sitzung woanders, als es sie vorgefunden hat. Das nächste Skript
  oder der Mensch an der Konsole erlebt eine Überraschung.
- Ein relativer Pfad wie `reports` bedeutet je nach Startort etwas anderes. Als geplante
  Aufgabe ist das meist der Systemordner.

Die Lösung: Jeder Befehl bekommt einen vollen Pfad. Baue ihn aus einer Variablen, die den
Wurzelordner enthält. In doppelten Anführungszeichen ersetzt PowerShell die Variable durch
ihren Wert.

`.` steht für den aktuellen Ort und `..` für den darüber.

## Beispiel

```powershell
Set-Location -Path $Root
$Files = Get-ChildItem -Path reports

$Files = Get-ChildItem -Path "$Root/reports"
```

Die Zeilen 1 und 2 hängen davon ab, wo die Sitzung steht. Zeile 4 liefert dieselben Dateien
und lässt den Ort in Ruhe.
