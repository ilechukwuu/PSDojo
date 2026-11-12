# Aufgabe

Das Service-Desk-Werkzeug zeigt zu jedem Alarm eine empfohlene Aktion und eine Serverrolle.
Dein Skript erhält `$Status` und `$Server`.

1. Setze `$Action` mit einem `switch` über `$Status`:
   - `Running` ergibt `Nothing to do`
   - `Stopped` ergibt `Start the service`
   - `Paused` ergibt `Resume the service`
   - alles andere ergibt `Check by hand`
2. Setze `$Role` mit einem `switch -Wildcard` über `$Server`:
   - Namen, die mit `FS-` beginnen, ergeben `File server`
   - Namen, die mit `PRN-` beginnen, ergeben `Print server`
   - Namen, die mit `APP-` beginnen, ergeben `Application server`
   - alles andere ergibt `Unknown`

Lass die Zeile mit `param` unverändert.
