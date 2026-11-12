# Was die Formate behalten und was sie verlieren

**CSV behält keine Typen.** Jeder Wert kommt als Text zurück, egal was er vorher war. Die
Folgen zeigen sich später und leise:

- Vergleichen: `'100' -lt '20'` ist wahr, weil 1 vor 2 kommt.
- Sortieren: 100, 20 und 9 sortieren sich als 100, 20, 9.
- Addieren mit `+` fügt die Texte zusammen.
- `Measure-Object -Sum` ist eine Ausnahme. Es wandelt selbst um und addiert richtig.

Um eine Textspalte als Zahlen zu sortieren, sortiere nach einem Ausdruck:
`Sort-Object -Property { [int]$_.FreeGB }`.

**JSON behält Typen.** Eine Zahl ohne Anführungszeichen kommt als Zahl zurück, `true` als
Wahrheitswert. Eine Zahl in Anführungszeichen ist auch in JSON Text.

**JSON verliert Tiefe.** `ConvertTo-Json` ohne `-Depth` wandelt zwei Ebenen um. Was darunter
liegt, wird durch einen Text ersetzt. PowerShell 7 gibt immerhin eine Warnung aus. Windows
PowerShell 5.1 nicht.

## Beispiel

```powershell
$Rows = Import-Csv -Path disks.csv
$Rows | Sort-Object -Property FreeGB
$Rows | Sort-Object -Property { [int]$_.FreeGB }
($Rows | Measure-Object -Property FreeGB -Sum).Sum
```

Zeile 2 sortiert als Text, Zeile 3 als Zahlen. Zeile 4 ist eine richtige Summe.
