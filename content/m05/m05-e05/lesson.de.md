# Pipeline oder Variablen

Dieselbe Arbeit lässt sich in zwei Stilen schreiben. Der eine speichert jedes
Zwischenergebnis in einer Variablen und füttert damit die nächste Zeile. Der andere verbindet
die Befehle direkt.

Variablen namens `$a`, `$tmp` oder `$x2`, die nur ein Ergebnis eine Zeile weitertragen,
bringen nichts. Der Leser muss sich Namen merken, die nichts bedeuten, und jede hält alle
ihre Objekte im Speicher, bis das Skript endet. Eine Pipeline sagt dasselbe in einem Satz.

Behalte eine Variable, wenn sie ihren Namen verdient:

- Du brauchst das Ergebnis mehr als einmal.
- Der Name erklärt etwas, das der Code nicht sagt, etwa `$StaleAccounts`.
- Du willst beim Debuggen ein Zwischenergebnis ansehen.

Wird die Pipeline länger als der Bildschirm breit ist, brich sie nach einem Pipe-Zeichen um
und rücke die folgenden Zeilen um vier Leerzeichen ein.

## Beispiel

```powershell
$a = Get-Process
$b = $a | Sort-Object -Property WorkingSet64 -Descending
$Top = $b | Select-Object -First 3

$Top = Get-Process |
    Sort-Object -Property WorkingSet64 -Descending |
    Select-Object -First 3
```

Beide Fassungen liefern dieselben drei Prozesse. In der zweiten gibt es nichts zu merken.
