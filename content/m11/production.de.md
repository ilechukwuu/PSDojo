# Was in der Produktion schiefgeht

Ein Hilfsskript liefert den Namen der neuesten Backup-Datei. Der Autor ergänzt eine
freundliche Fortschrittszeile, damit er sieht, was passiert:

```powershell
Write-Output 'Searching for the newest backup ...'
Write-Output $Newest.FullName
```

Ein anderes Skript speichert das Ergebnis in einer Variablen und übergibt es an
`Restore-SqlDatabase`. Die Variable enthält jetzt zwei Dinge: den Fortschrittstext und den
Pfad. Die Wiederherstellung scheitert nachts an einem Pfad, der mit dem Wort Searching
beginnt.

Alles, was mit `Write-Output` geschrieben wird, und jeder Wert, der einfach in einer Zeile
stehen bleibt, wird Teil des Ergebnisses. Meldungen für Menschen gehören in `Write-Verbose`,
`Write-Warning` oder `Write-Host`, nie in die Ausgabe.
