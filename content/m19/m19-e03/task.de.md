# Aufgabe

Ein Kollege schickt dir vier Schleifen aus einem Entwurf des Patchskripts und fragt, wie oft
jeder Block läuft. Sage die Werte vorher. Führe nichts aus.

```powershell
$A = 0
for ($i = 0; $i -lt 10; $i += 3) { $A++ }

$B = 0
$Queue = 5
while ($Queue -gt 0) { $Queue -= 2; $B++ }

$C = 0
do { $C++ } while ($C -gt 5)

$D = 0
foreach ($Number in 1..6) {
    if ($Number -eq 2) { continue }
    if ($Number -eq 5) { break }
    $D++
}
```

Speichere die Endwerte von `$A`, `$B`, `$C` und `$D` in `$ResultA`, `$ResultB`, `$ResultC`
und `$ResultD`.
