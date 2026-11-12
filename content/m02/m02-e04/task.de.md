# Aufgabe

Das Skript in deiner Übungsdatei addiert den freien Speicherplatz von vier Dateiservern und
merkt sich einen Server, dem der Platz ausgeht. Die Schleife musst du noch nicht verstehen.
Lass dir vom Debugger zeigen, was passiert.

Setze einen Haltepunkt in der Zeile `$Total = $Total + $FreeGB[$i]` und starte mit F5. Jedes
Mal, wenn das Skript hält, drücke einmal F10 und lies dann `$Total` in der Konsole.

1. Welchen Wert hat `$Total`, nachdem die Zeile zum zweiten Mal gelaufen ist? Speichere ihn
   in `$TotalAfterSecondPass`.
2. Welcher Servername steht am Ende in `$Low`? Speichere ihn als Text in `$LowServer`.
3. Welchen Wert hat `$Total`, wenn das Skript fertig ist? Speichere ihn in `$FinalTotal`.
