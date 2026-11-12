# Rechnen und zuweisen

Die Rechenoperatoren sind die bekannten: `+`, `-`, `*`, `/`. Einer mehr ist in Skripten
nützlich: `%`, genannt Modulo. Er liefert den Rest einer Division. `10 % 3` ist 1. Das
beantwortet Fragen wie "wie viele Dateien bleiben nach vollen Stapeln übrig".

Größen lassen sich mit Einheiten schreiben. `1KB`, `1MB`, `1GB` und `1TB` sind Zahlen: `1GB`
ist 1073741824. Eine Größe in Bytes geteilt durch `1GB` ergibt Gigabyte.

Für das Ändern einer Variablen anhand ihres eigenen Werts gibt es Kurzformen:

- `$Count += 5` addiert 5 zu dem, was in `$Count` steht.
- `$Count -= 1` subtrahiert.
- `$Count++` addiert genau eins, `$Count--` zieht eins ab.

Multiplikation und Division kommen vor Addition und Subtraktion. Runde Klammern ändern diese
Reihenfolge.

## Beispiel

```powershell
$TotalBytes = 536870912000
$TotalGB = $TotalBytes / 1GB

$Files = 47
$LeftOver = $Files % 10

$Checked = 0
$Checked += 5
$Checked++
```

`$TotalGB` ist 500, `$LeftOver` ist 7 und `$Checked` endet bei 6.
