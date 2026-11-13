# Aufgabe

Bevor der Nordwind-Dienst startet, prüft ein Skript, ob seine Konfigurationsdateien da sind.
Die Version in deiner Übungsdatei klebt Pfade zusammen und listet den Ordner für jede einzelne
Datei. Schreibe sie um.

1. Baue den Pfad des Ordners `config` unterhalb von `$Root` mit `Join-Path`.
2. Baue den Pfad jeder benötigten Datei mit `Join-Path` und frage mit `Test-Path`, ob es sie
   gibt.
3. `$Missing` enthält wie bisher die Namen der benötigten Dateien, die fehlen.
4. Kein `+` zum Verbinden von Text und kein `Get-ChildItem` darf übrig bleiben.

Lass die ersten zwei Zeilen unverändert.
