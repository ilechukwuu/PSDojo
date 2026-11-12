# Aufgabe

Der Befehl `Get-Volume` liefert auf dem Dateiserver FS-02 vier Volumes in dieser Reihenfolge:

```powershell
DriveLetter FreeGB
----------- ------
C               42
D              310
E                8
F              125
```

Sage die Ergebnisse vorher, ohne etwas auszuführen.

1. `Get-Volume | Sort-Object -Property FreeGB | Select-Object -First 1`
   Welcher Laufwerksbuchstabe kommt heraus? Speichere ihn als Text in `$FirstResult`.
2. `Get-Volume | Select-Object -First 2 | Sort-Object -Property FreeGB -Descending`
   Welcher Laufwerksbuchstabe steht im Ergebnis vorn? Speichere ihn in `$SecondResult`.
3. `Get-Volume | Sort-Object -Property FreeGB -Descending | Select-Object -First 3 | Measure-Object`
   Welche Zahl steht in der Eigenschaft Count? Speichere sie in `$ThirdResult`.
