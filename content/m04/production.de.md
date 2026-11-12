# Was in der Produktion schiefgeht

Ein Aufräumskript beginnt mit `Set-Location D:\Temp\Scans` und löscht dann mit einem
relativen Pfad:

```powershell
Set-Location -Path D:\Temp\Scans
Remove-Item -Path * -Recurse -Force
```

Eines Nachts ist Laufwerk D: offline. `Set-Location` scheitert, das Skript läuft weiter, und
die zweite Zeile läuft dort, wo die Sitzung gerade steht. Als geplante Aufgabe ist das
`C:\Windows\System32`.

Lass einen zerstörenden Befehl nie vom aktuellen Ort abhängen. Gib ihm einen vollen Pfad und
sorge dafür, dass das Skript anhält, wenn ein Schritt davor scheitert.
