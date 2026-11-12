# Aufgabe

Die zwei Zeilen in deiner Übungsdatei gehören zu einer Prüfung, die jede Minute gegen APP-01
läuft. Jede holt alle Dienste und wirft die meisten wieder weg.

Schreibe sie so um, dass `Get-Service` selbst nach Namen filtert:

1. `$NordwindDown`: Der Namensfilter wandert in den Parameter `-Name`. Der Status bleibt in
   `Where-Object`.
2. `$Sql`: Beide Namen gehen als Liste an `-Name`. `Where-Object` wird nicht mehr gebraucht.

Beide Variablen müssen dieselben Dienste enthalten wie jetzt.
