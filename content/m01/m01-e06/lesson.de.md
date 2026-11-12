# Aliase

Ein Alias ist ein zweiter, kürzerer Name für ein Cmdlet. `gps` startet `Get-Process`, `?`
startet `Where-Object`, `%` startet `ForEach-Object` und `select` startet `Select-Object`.

In der Konsole sparen Aliase Tipparbeit, dafür sind sie da. In einem Skript kosten sie mehr,
als sie sparen:

- Der Nächste muss jede Abkürzung entschlüsseln, bevor er beurteilen kann, was das Skript
  tut.
- Nicht jeder Alias existiert überall. `ls`, `cat` und `sort` sind unter Windows Aliase.
  Unter Linux und macOS starten diese Namen stattdessen die nativen Programme, mit anderen
  Ergebnissen.

Die Regel ist deshalb einfach: In der Konsole tippst du, was du willst. In allem, was du
speicherst, stehen volle Cmdlet-Namen.

`Get-Alias -Name` verrät dir, welches Cmdlet hinter einem Alias steckt.

## Beispiel

```powershell
Get-Alias -Name gps

gps | ? { $_.Name -eq 'spoolsv' }

Get-Process | Where-Object { $_.Name -eq 'spoolsv' }
```

Die erste Zeile löst den Alias auf. Die zweite und dritte Zeile tun exakt dasselbe. Nur die
dritte gehört in ein Skript.
