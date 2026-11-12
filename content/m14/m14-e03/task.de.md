# Aufgabe

Neue Server bekommen nummerierte Namen, und der Wochenbericht braucht saubere Zeilen. Die
ersten Zeilen deiner Übungsdatei enthalten die Daten. Lass sie unverändert.

Nutze in jeder Zeile den Formatoperator `-f`.

1. Speichere den Servernamen `APP-012` in `$ServerName`: der Text `APP-`, dann `$Number` mit
   drei Stellen.
2. Speichere das Datum in `$Start` als Text im Aufbau `yyyy-MM-dd` in `$Stamp`.
3. Speichere den Dateinamen `report_APP-012_2026-03-14.csv` in `$FileName`, gebaut aus
   `$ServerName` und `$Stamp` mit zwei Platzhaltern.
4. Speichere eine Berichtszeile in `$Row`: `$ServerName` linksbündig in 10 Zeichen, direkt
   gefolgt von `$FreeGB` rechtsbündig in 6 Zeichen.
