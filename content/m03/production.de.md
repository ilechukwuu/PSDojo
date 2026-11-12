# Was in der Produktion schiefgeht

Ein Admin soll alte Logdateien aufräumen und findet in einem alten Ticket einen Befehl:

```powershell
Remove-Item -Path D:\Logs -Recurse -Force
```

Er führt ihn aus, ohne die Hilfe zu lesen. `-Recurse` entfernt den Ordner mit allem darin,
`-Force` schließt versteckte und schreibgeschützte Dateien ein, und nichts fragt nach. Der
Ordner, in den der Backup-Job schreibt, ist ebenfalls weg.

Dreißig Sekunden mit `Get-Help Remove-Item -Parameter Recurse` und ein erster Lauf mit
`-WhatIf` hätten genau gezeigt, was passieren würde. Lies die Hilfe zu jedem Parameter, den
du nicht selbst gewählt hast.
