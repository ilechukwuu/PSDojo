# Aufgabe

Ein Deployment-Werkzeug teilt jedem Skript über die Umgebungsvariable `DOJO_SITE` mit, an
welchem Standort es läuft. Zum Üben setzt die erste Zeile deiner Übungsdatei sie. Lass diese
Zeile unverändert und arbeite darunter mit dem Laufwerk `Env:`.

1. Speichere alle Umgebungsvariablen in `$AllVariables`.
2. Speichere den Wert von `DOJO_SITE` in `$Site`. Nur den Wert, nicht das ganze Item.
3. Lege mit `New-Item` die Umgebungsvariable `DOJO_TICKET` mit dem Wert `INC-4711` an.
4. Speichere in `$TicketExists`, ob `DOJO_TICKET` existiert. Nutze `Test-Path`.
