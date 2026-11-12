# Aufgabe

Der Service Desk will den Zustand der Nordwind-Dienste auf APP-01 als Textdatei am Ticket
und zusätzlich im Tickettext. Das Dojo übergibt den Zielordner als `$ReportFolder`.

1. Schreibe eine Tabelle der Dienste, deren Name mit `Nordwind` beginnt, mit den Spalten
   `Name`, `Status` und `StartType` in die Datei `nordwind.txt` in `$ReportFolder`. Nutze
   `-Encoding utf8` und `-Width 200`.
2. Speichere dieselbe Tabelle als Text in `$TicketText`, ebenfalls mit `-Width 200`.

Lass die Zeile mit `param` unverändert.
