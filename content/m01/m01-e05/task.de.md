# Aufgabe

Das Wartungsfenster für die Dateiserver ist für den 14. März 2026 um 22:00 Uhr geplant. Das
Change-Ticket braucht ein paar Werte von dir.

1. Speichere den Beginn des Wartungsfensters als Datumsobjekt in `$PatchStart`: 14. März
   2026, 22:00:00 Uhr. Nutze `Get-Date` mit den Parametern `-Year`, `-Month`, `-Day`, `-Hour`,
   `-Minute` und `-Second`.
2. Die Berichtsdatei bekommt das heutige Datum in den Namen. Speichere das heutige Datum als
   Text im Format `yyyyMMdd` in `$TicketStamp`.
3. Zwei Prozesse müssen vor dem Patchen laufen. Speichere die Prozesse `spoolsv` und `lsass`
   mit einem einzigen Aufruf von `Get-Process` in `$Watched`.
4. Speichere die Syntax von `Stop-Process` in `$Syntax`. Nutze `Get-Command` mit dem Schalter
   `-Syntax`.

Schreibe jeden Parameternamen aus.
