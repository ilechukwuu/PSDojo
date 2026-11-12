# Aufgabe

Für den Archivjob auf FS-02 berechnest du ein paar Werte. Die ersten Zeilen deiner
Übungsdatei enthalten die Rohzahlen. Lass sie unverändert.

1. Speichere die Summe von `$SizeC` und `$SizeD` in Gigabyte in `$TotalGB`. Beide stehen in
   Bytes.
2. Speichere den freien Anteil in Prozent als ganze Zahl in `$FreePercent`: `$FreeBytes`
   geteilt durch die Summe beider Größen, mal 100, gerundet.
3. Der Archivjob verschiebt Dateien in Stapeln von `$BatchSize`. Speichere in `$LeftOver`,
   wie viele Dateien nach dem letzten vollen Stapel übrig bleiben.
4. `$Processed` beginnt bei 120. Addiere `$BatchSize` mit `+=` dazu und zähle es dann mit
   `++` um eins hoch.
