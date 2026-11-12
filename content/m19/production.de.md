# Was in der Produktion schiefgeht

Ein Skript wartet nach einem Neustart darauf, dass ein Dienst hochkommt, bevor es
weitermacht:

```powershell
while ((Get-Service -Name NordwindApi).Status -ne 'Running') {
    Start-Sleep -Seconds 5
}
```

Eines Nachts startet der Dienst nicht, weil ein Zertifikat abgelaufen ist. Sein Status bleibt
Stopped, die Bedingung bleibt wahr, und die Schleife wartet ewig. Die geplante Aufgabe endet
nie, der Lauf der nächsten Nacht kann nicht starten, weil der vorige noch aktiv ist, und
niemand wird alarmiert, weil nichts gescheitert ist.

Jede Schleife, die auf etwas außerhalb des Skripts wartet, braucht einen zweiten Ausgang:
eine Höchstzahl von Versuchen oder eine Frist, und einen Fehler, wenn diese Grenze erreicht
ist.
