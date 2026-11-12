# Standardmäßig still

Skripte werden beim Schreiben geschwätzig. Jeder Schritt bekommt eine Zeile `Write-Host`,
damit der Autor mitverfolgen kann. In der Produktion ist dieses Geschwätz ein Problem.

- Eine geplante Aufgabe hat keinen Bildschirm. Die Zeilen gehen ins Leere, oder sie füllen
  ein Log mit Rauschen, das die eine wichtige Zeile verdeckt.
- Läuft das Skript gegen zweihundert Server, liest niemand achthundert Statuszeilen.
- Ein Kollege, der das Skript aus seinem eigenen aufruft, kann sie nicht abschalten.

Die Konvention unter Werkzeugautoren ist einfach: Ein Werkzeug sagt nichts, solange nichts
falsch ist oder der Aufrufer fragt. Fortschrittsnotizen werden zu `Write-Verbose`, Dinge,
die Aufmerksamkeit brauchen, zu `Write-Warning`, und standardmäßig kommt nur das Ergebnis
heraus.

Behalte `Write-Host` für Skripte, denen ein Mensch zusehen soll, etwa eine interaktive
Einrichtung.

## Beispiel

```powershell
Write-Host 'Connecting to APP-01'
Write-Host 'Reading services'

Write-Verbose -Message 'Connecting to APP-01'
Write-Verbose -Message 'Reading services'
```

Die ersten zwei Zeilen geben immer aus. Die letzten zwei nur, wenn jemand sie sehen will.
