# Aufgabe

Der nächtliche Berichtsjob braucht seinen Ausgabeordner. Auf einem neuen Server fehlt der
Ordner, auf einem alten ist er da und voller Berichte. Dein Skript muss mit beidem
zurechtkommen. Das Dojo übergibt den Basisordner als `$Root`.

1. Baue den Pfad des Ordners `Reports` unterhalb von `$Root` mit `Join-Path` und speichere
   ihn in `$ReportDir`.
2. Speichere in `$Existed`, ob dieser Ordner in diesem Moment existiert, bevor du etwas
   anlegst.
3. Lege den Ordner an, wenn es ihn nicht gibt. In einem vorhandenen Ordner darf nichts
   verloren gehen.
4. Baue den Pfad der Datei `status.txt` in `$ReportDir` und speichere ihn in `$StatusFile`.
5. Schreibe den Text `ready` in diese Datei.

Lass die Zeile mit `param` unverändert.
