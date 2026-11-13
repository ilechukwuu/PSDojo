# Aufgabe

Das Skript in deiner Übungsdatei gibt die Namen von Berichtsdateien aus, die älter als eine
Zahl von Tagen sind. Ordner und Zahl stehen als globale Variablen darin. Schreibe es um.

1. Ergänze einen `param`-Block mit `$Path` (Text, Standardwert `D:\Reports`) und `$Days`
   (ganze Zahl, Standardwert `30`).
2. Nutze die Parameter statt der globalen Variablen.
3. Keine `$global:`-Variable darf übrig bleiben. Das Grenzdatum ist eine gewöhnliche
   Variable.

Das Skript gibt weiterhin die Namen der Dateien in `$Path` aus, die vor mehr als `$Days`
Tagen zuletzt geschrieben wurden.
