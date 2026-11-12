# Mit Aliasen arbeiten

`Get-Alias` sucht in beide Richtungen.

- `-Name` geht vom Alias aus und zeigt das Cmdlet dahinter. Mehrere Namen auf einmal sind
  erlaubt.
- `-Definition` geht vom Cmdlet aus und zeigt jeden Alias, der darauf zeigt.

Jedes Ergebnis ist ein Objekt. Sein `Name` ist der Alias, seine `Definition` ist das Cmdlet.

Mit `Set-Alias` legst du eigene Aliase an. Zwei Dinge musst du wissen:

- Dein Alias lebt nur in der aktuellen Sitzung. Schließt du das Fenster, ist er weg.
- Ein Alias ist ein Name für einen Befehl, mehr nicht. Parameter kann er nicht mitnehmen.

Windows PowerShell 5.1 und PowerShell 7 bringen nicht dieselben Aliase mit, und PowerShell 7
hat unter Linux und macOS weniger als unter Windows. Verlasse dich nie darauf, dass es einen
Alias gibt. Schlag nach.

## Beispiel

```powershell
Get-Alias -Name gci, gcm
Get-Alias -Definition Get-ChildItem
Set-Alias -Name events -Value Get-Event
```

Die erste Zeile löst zwei Aliase auf. Die zweite listet jeden Alias für `Get-ChildItem`. Die
dritte legt für diese Sitzung den Alias `events` an.
