# Aufgabe

Das Kapazitätswerkzeug exportiert eine CSV-Datei mit den Spalten `Server`, `Drive` und
`FreeGB`, getrennt durch Semikolons. Du suchst die Volumes heraus, denen der Platz ausgeht,
und gibst sie als neue Datei weiter. Das Dojo übergibt den Ordner als `$Folder`. Die
Eingabedatei ist `disks.csv` darin.

1. Lies `disks.csv` und speichere die Zeilen in `$Rows`.
2. Speichere die Zeilen, deren `FreeGB` unter 20 liegt, in `$Low`. Vergleiche als Zahl.
3. Schreibe `$Low` in die Datei `low.csv` in `$Folder`, getrennt durch Semikolons, ohne die
   Typzeile, kodiert als UTF-8.

Lass die Zeile mit `param` unverändert.
