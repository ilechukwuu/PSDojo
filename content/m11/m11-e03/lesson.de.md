# Umleitung

Jeder Strom lässt sich mit einem Umleitungsoperator woandershin schicken. Die Zahl davor
sagt, welcher Strom gemeint ist.

- `> Datei` schickt das Ergebnis in eine Datei und überschreibt sie. `>> Datei` hängt an.
- `2> Datei` schickt Fehler dorthin, `3> Datei` Warnungen, `4> Datei` Verbose-Meldungen.
- `*> Datei` schickt jeden Strom.
- `2>$null` wirft Fehler weg. Nutze es sparsam: Einen Fehler, den du nicht siehst, kannst du
  nicht beheben.
- `2>&1` mischt den Fehlerstrom in das Ergebnis, sodass eine Variable oder Datei beides
  bekommt. `3>&1` tut dasselbe für Warnungen.

Eine Zuweisung an eine Variable fängt Strom 1 auf und sonst nichts. Warnungen, Fehler und
Text von `Write-Host` gehen daran vorbei auf den Bildschirm, wenn du sie nicht hineinmischst.

`Write-Host` schreibt seit PowerShell 5 in Strom 6. In älteren Versionen ließ es sich gar
nicht umleiten.

## Beispiel

```powershell
$Result = Get-ChildItem -Path D:\Reports, D:\Missing 2>$null
Get-ChildItem -Path D:\Reports, D:\Missing 2> errors.log
$All = Get-ChildItem -Path D:\Reports, D:\Missing 2>&1
```

Zeile 1 behält die Dateien und verwirft den Fehler. Zeile 2 protokolliert den Fehler. Zeile 3
legt beides in die Variable.
