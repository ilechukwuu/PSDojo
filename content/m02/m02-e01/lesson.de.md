# Skriptbereich und Konsole

Beide Editoren, die PowerShell ISE und VS Code mit der PowerShell-Erweiterung, haben zwei
Bereiche. Im Skriptbereich schreibst und speicherst du eine Datei. In der Konsole darunter
laufen Befehle und erscheinen Ergebnisse. Beide Bereiche teilen sich eine Sitzung: Eine
Variable, die das Skript setzt, steht danach in der Konsole zur Verfügung.

Zwei Tasten sind am wichtigsten, und sie sind in beiden Editoren gleich:

- **F5** führt die ganze Datei aus.
- **F8** führt nur aus, was du markiert hast. Ohne Markierung führt VS Code die aktuelle
  Zeile aus, die ISE nichts.

Mit F8 erkundest du: eine Zeile ausprobieren, Ergebnis ansehen, nächste Zeile. Auf einem
Server ist es außerdem die sichere Gewohnheit, denn F5 führt in einem halbfertigen Skript
jede Zeile aus.

Die ISE führt nur Windows PowerShell 5.1 aus. VS Code führt 5.1 und PowerShell 7 aus.

## Beispiel

```powershell
Get-Date
Get-Process -Name spoolsv
```

Klicke in die erste Zeile und markiere sie. F8 gibt das Datum aus und sonst nichts. F5 würde
beide Zeilen ausführen.
