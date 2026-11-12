# Task

A colleague sends you four loops from a draft of the patch script and asks how often each
block runs. Predict the values. Do not run anything.

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

Store the final values of `$A`, `$B`, `$C` and `$D` in `$ResultA`, `$ResultB`, `$ResultC`
and `$ResultD`.
