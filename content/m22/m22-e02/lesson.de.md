# Dateien finden

`Get-ChildItem` listet, was in einem Ordner liegt. Vier Parameter machen daraus eine Suche:

- `-Recurse` geht in jeden Unterordner hinunter. Ohne es wird nur die oberste Ebene gelistet.
- `-File` liefert nur Dateien, `-Directory` nur Ordner.
- `-Filter '*.log'` schränkt nach Namen ein. Der Provider filtert dabei selbst, das ist viel
  schneller als `Where-Object` danach.
- `-Force` schließt versteckte Elemente ein.

Jedes Ergebnis ist ein Objekt. Bei Dateien sind die meistgenutzten Eigenschaften `Name`,
`FullName`, `Extension`, `Length` (die Größe in Bytes) und `LastWriteTime` (ein Datum).

Alter und Größe sind damit gewöhnliche Vergleiche. Berechne die Grenze einmal vor der
Pipeline und vergleiche mit ihr. Größen lassen sich mit Einheiten schreiben: `100MB` ist eine
Zahl.

`Measure-Object -Property Length -Sum` addiert Größen.

## Beispiel

```powershell
$Limit = (Get-Date).AddDays(-90)

$Old = Get-ChildItem -Path D:\Shares\Projects -Recurse -File -Filter '*.bak' |
    Where-Object { $_.LastWriteTime -lt $Limit -and $_.Length -gt 100MB }

($Old | Measure-Object -Property Length -Sum).Sum / 1GB
```
