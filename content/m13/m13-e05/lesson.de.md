# Kürzere Bedingungen

Eine Bedingung, die einen Wert mit mehreren Möglichkeiten vergleicht, wächst mit jeder neuen
Möglichkeit:

`$Status -eq 'Stopped' -or $Status -eq 'Paused' -or $Status -eq 'StartPending'`

Jede Ergänzung ist eine Gelegenheit, die Variable zu vertippen oder den falschen Operator zu
nehmen, und die Zeile läuft bald aus dem Bildschirm.

`-in` sagt dasselbe in wenigen Worten. Der Wert steht links, die Liste der erlaubten Werte
rechts. Das Ergebnis ist wahr, wenn der Wert einer davon ist. `-notin` ist das Gegenteil.

Lege die Liste in eine Variable mit sprechendem Namen und du gewinnst doppelt: Die Bedingung
liest sich wie ein Satz, und ein neuer Wert ist ein Wort mehr in der Liste oben.

`-contains` tut dasselbe mit vertauschten Seiten, die Liste links.

## Beispiel

```powershell
$ProblemStates = 'Stopped', 'Paused', 'StartPending'

$NeedsAttention = $Status -in $ProblemStates
$IsFine = $Status -notin $ProblemStates
```

Zeile 3 ersetzt eine Kette von drei Vergleichen.
