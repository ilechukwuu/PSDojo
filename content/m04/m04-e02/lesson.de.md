# Ein Satz Cmdlets für jedes Laufwerk

Was auf einem Laufwerk liegt, heißt Item: eine Datei, ein Ordner, eine Umgebungsvariable, ein
Alias. Die Item-Cmdlets arbeiten auf jedem Laufwerk gleich.

- `Get-ChildItem` listet, was an einem Ort liegt.
- `Get-Item` liefert ein einzelnes Item.
- `Test-Path` antwortet mit `$true` oder `$false`, ob ein Item existiert.
- `New-Item` legt eines an, `Remove-Item` löscht eines.

Ein Pfad beginnt mit dem Laufwerksnamen und einem Doppelpunkt, zum Beispiel
`Env:COMPUTERNAME`.

Umgebungsvariablen sind Einstellungen, die das Betriebssystem jedem Programm mitgibt.
Deployment-Werkzeuge sagen einem Skript damit oft, wo es läuft. Auf dem Laufwerk `Env:` ist
jede Variable ein Item mit `Name` und `Value`.

Eine Variable, die du dort anlegst, existiert nur in deiner aktuellen Sitzung. Namen von
Umgebungsvariablen unterscheiden unter Linux und macOS Groß- und Kleinschreibung, unter
Windows nicht.

## Beispiel

```powershell
Get-ChildItem -Path Env:
Get-Item -Path Env:COMPUTERNAME
(Get-Item -Path Env:COMPUTERNAME).Value
Test-Path -Path Env:DOJO_SITE
New-Item -Path Env:DOJO_SITE -Value 'Kiel'
```

Zeile 3 liest nur den Wert. Zeile 4 prüft, bevor Zeile 5 anlegt.
