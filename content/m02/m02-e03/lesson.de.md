# Syntaxfehler

Manche Fehler verhindern, dass PowerShell ein Skript überhaupt lesen kann: ein
Anführungszeichen, das nie geschlossen wird, eine Klammer ohne Partner. Das sind
Syntaxfehler. Nichts läuft, bis sie behoben sind, auch nicht die Zeilen über dem Fehler.

Dein Editor findet sie beim Tippen:

- Beide Editoren unterstreichen die Stelle mit einer roten Wellenlinie. Fahre mit der Maus
  darüber, um die Meldung zu lesen.
- VS Code listet zusätzlich jedes Problem im Bereich Probleme, Strg+Umschalt+M.
- Farben helfen auch. Hat plötzlich die halbe Datei die Farbe von Text, ist ein
  Anführungszeichen offen.
- Steht der Cursor neben einer Klammer, hebt der Editor ihren Partner hervor.

Die Wellenlinie sitzt oft hinter dem eigentlichen Fehler, weil PowerShell das Problem erst
bemerkt, wenn der Rest keinen Sinn mehr ergibt. Schau zuerst auf die markierte Stelle, dann
nach links und nach oben.

## Beispiel

```powershell
$Name = 'FS-02
$Size = (120 + 80
```

In Zeile 1 fehlt das schließende Anführungszeichen, deshalb ist Zeile 2 als Text eingefärbt.
Nach dem Schließen zeigt Zeile 2 ihr eigenes Problem: Die schließende Klammer fehlt.
