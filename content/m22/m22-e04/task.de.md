# Aufgabe

Vor jedem Update der Nordwind-Anwendung sichert ein Skript die Konfiguration und räumt die
Logdateien aus dem Weg. Nach dem letzten Update war der Sicherungsordner leer, und die Logs
lagen noch an ihrem Platz. Das Skript in deiner Übungsdatei hat drei Fehler. Behebe sie. Lass
die Zeile mit `param` unverändert.

Wenn das Skript funktioniert:

- Der Ordner `backup` unterhalb von `$Root` enthält alles aus `config`, einschließlich des
  Unterordners.
- Der Ordner `archive` unterhalb von `$Root` existiert und enthält jede `.log`-Datei aus
  `logs`.
- Andere Dateien in `logs` bleiben, wo sie sind.
