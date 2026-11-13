# Aufgabe

Laufwerk D: von APP-01 läuft voll. Du willst wissen, wie viel Platz die alten Logdateien der
Anwendung belegen, auch die in Unterordnern. Das Dojo übergibt den Logordner als `$Root`.

1. Speichere jede Datei mit der Endung `.log` unterhalb von `$Root`, in allen Unterordnern,
   in `$Logs`. Nur Dateien.
2. Speichere diejenigen davon, die vor mehr als 30 Tagen zuletzt geschrieben wurden, in
   `$OldLogs`.
3. Speichere die Gesamtgröße von `$OldLogs` in Bytes in `$TotalBytes`.
4. Speichere den Namen der größten Datei in `$OldLogs` in `$Largest`.

Lass die Zeile mit `param` unverändert.
