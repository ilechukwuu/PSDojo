# Aufgabe

Die Überwachung exportiert zwei Beobachtungslisten für den Terminalserver TS-03. Die ersten
Zeilen deiner Übungsdatei enthalten sie als Objekte, so wie `Import-Csv` sie liefern würde.
Lass diese Zeilen unverändert.

1. Leite `$WatchList` in `Get-Process` und speichere das Ergebnis in `$Running`. Die Spalte
   heißt `Name`.
2. Leite `$LegacyList` in `Get-Process` und speichere das Ergebnis in `$Legacy`. Ihre Spalte
   heißt `ProcessName`, das ist ein Alias des Parameters `-Name`.
3. Leite `$AliasList` in `New-Alias`. Jede Zeile hat die Spalten `Name` und `Value`, und
   beide binden. Danach existieren die Aliase `procs` und `items`.
