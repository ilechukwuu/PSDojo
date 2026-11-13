# Aufgabe

Alle Wartungsskripte von Nordwind teilen sich eine Datei `settings.ps1`. Sie setzt die
Variable `$Site` und gibt den Text `settings loaded` aus. Du zeigst einer Kollegin den
Unterschied zwischen Aufrufen und Dot-Sourcing. Das Dojo übergibt den Ordner als `$Folder`.

1. Baue den Pfad von `settings.ps1` in `$Folder` und speichere ihn in `$SettingsFile`.
2. Starte die Datei mit dem Aufrufoperator und speichere ihre Ausgabe in `$Output`.
3. Speichere den Wert von `$Site` in diesem Moment in `$AfterCall`.
4. Binde die Datei mit Dot-Sourcing ein. Verwirf ihre Ausgabe.
5. Speichere den Wert von `$Site` in diesem Moment in `$AfterDot`.

Lass die Zeile mit `param` unverändert.
