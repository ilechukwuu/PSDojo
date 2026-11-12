# Zwei Arten von Ausgabe

Ein Skript erzeugt zwei Arten von Dingen, und PowerShell hält sie in getrennten Kanälen
auseinander, den Strömen.

**Das Ergebnis.** Das sind die Daten, für die das Skript existiert. Sie gehen in den
Erfolgsstrom, Strom 1. Nur dieser Strom fließt durch die Pipe und in eine Variable.
`Write-Output` schreibt dorthin, und ebenso jeder Wert, der allein in einer Zeile steht. Die
meisten Skripte müssen `Write-Output` nie ausschreiben.

**Meldungen für Menschen.** Eine Überschrift, ein Hinweis, dass die Prüfung fertig ist.
`Write-Host` schreibt sie auf den Bildschirm. Sie gehören nicht zum Ergebnis: Eine Variable,
die das Skript auffängt, enthält sie nicht.

Die Frage ist also immer, für wen der Text ist. Soll ein anderer Befehl oder eine Variable
ihn bekommen, ist er ein Ergebnis. Soll ihn nur ein Mensch lesen, ist er eine Meldung.

## Beispiel

```powershell
Write-Host 'Service check for APP-01'
Get-Service | Where-Object { $_.Status -eq 'Stopped' } | Select-Object -ExpandProperty Name
```

Als Skript ausgeführt und in einer Variablen aufgefangen, enthält die Variable die
Dienstnamen. Die Überschrift erscheint am Bildschirm und sonst nirgends.
