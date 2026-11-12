# Eine Eigenschaft von vielen Objekten

Oft willst du nicht die Objekte, sondern nur eine Angabe zu jedem: die Namen aller Prozesse,
die Größen aller Dateien.

PowerShell macht das leicht. Liest du eine Eigenschaft an einer Liste und die Liste selbst
hat diese Eigenschaft nicht, liest PowerShell sie von jedem Element und gibt dir die Werte
als neue Liste. Das heißt Member Enumeration.

`(Get-Process).Name` ist also der Name jedes Prozesses. Die Elemente einzeln mit `[0]`, `[1]`,
`[2]` herauszupicken ist unnötig, und es bricht, sobald die Liste länger oder kürzer ist als
angenommen.

Die neue Liste kann direkt in den nächsten Befehl gehen, zum Beispiel in
`Measure-Object -Sum`, um Zahlen zu addieren.

Eine Falle: Eine Liste hat ein paar eigene Eigenschaften, vor allem `Count` und `Length`. Die
liefern die Anzahl der Elemente, nicht einen Wert von jedem.

## Beispiel

```powershell
$Files = Get-ChildItem -Path D:\Reports
$Files.Name
($Files.Length | Measure-Object -Sum).Sum
$Files.Count
```

Zeile 2 liefert jeden Dateinamen. Zeile 4 liefert, wie viele Dateien es sind.
