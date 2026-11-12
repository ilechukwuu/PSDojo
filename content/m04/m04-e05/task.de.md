# Aufgabe

Das Skript in deiner Übungsdatei sammelt Informationen über die Berichtsfreigabe. Es
funktioniert, wechselt aber zweimal den Ort und benutzt relative Pfade. Schreibe es so um,
dass es den Ort nie wechselt.

1. Entferne jedes `Set-Location` und jedes `cd`.
2. Gib jedem verbleibenden Befehl einen vollen Pfad, der mit `$Root` beginnt.

`$Reports`, `$HasArchive` und `$Readme` müssen genau das enthalten, was sie jetzt enthalten.
Lass die Zeile mit `param` unverändert.
