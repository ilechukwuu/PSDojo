# Select-String

`-match` prüft einen Text. `Select-String` durchsucht ganze Dateien oder viele Dateien auf
einmal nach einem Muster und liefert für jede passende Zeile ein Objekt.

Jedes dieser Objekte sagt dir, wo der Treffer liegt:

- `Line`: der Text der Zeile.
- `LineNumber`: ihre Nummer in der Datei.
- `Filename` und `Path`: die Datei, aus der sie stammt.

Nützliche Parameter:

- `-Path` versteht Platzhalter, `D:\Logs\*.log` durchsucht also jede Logdatei.
- `-Pattern` ist ein regulärer Ausdruck. Mehrere Muster lassen sich durch Kommas getrennt
  angeben.
- `-SimpleMatch` behandelt das Muster als reinen Text. Nutze es, wenn du etwas suchst, das
  Punkte oder Klammern enthält, und sie nicht maskieren willst.
- `-NotMatch` liefert die Zeilen, die nicht passen.
- `-Context 2` ergänzt die Ausgabe um die Zeilen rund um jeden Treffer.

Es ist die PowerShell-Antwort auf grep und findstr, mit dem Unterschied, dass das Ergebnis
Objekte sind.

## Beispiel

```powershell
$Hits = Select-String -Path D:\Logs\*.log -Pattern 'ERROR'
$Hits.Count
$Hits[0].LineNumber
$Hits.Line
```

Zeile 2 ist die Zahl der passenden Zeilen, Zeile 4 ihr Text.
