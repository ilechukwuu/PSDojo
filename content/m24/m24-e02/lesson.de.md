# Skriptblöcke übergeben

Viele Cmdlets haben Parameter vom Typ Skriptblock. `Where-Object -FilterScript`,
`ForEach-Object -Process` und `Sort-Object -Property` nutzt du bereits. Das Cmdlet
entscheidet, wann der Block läuft, und setzt `$_` jedes Mal auf das aktuelle Objekt.

Weil ein Block ein Wert ist, muss er nicht an der Stelle stehen, an der er benutzt wird.
Speichere ihn in einer Variablen und übergib die Variable:

`$Volumes | Where-Object -FilterScript $IsLow`

Nun kann dieselbe Regel drei verschiedene Listen filtern, und eine Änderung der Regel
passiert an einer Stelle.

Ein Fehler ist häufig. `Where-Object { $IsLow }` verpackt die Variable in einen neuen Block.
Dieser neue Block gibt nur den gespeicherten Block aus, und ein Objekt zählt als wahr. Der
Filter lässt alles durch. Übergib die Variable selbst, ohne Klammern darum.

Blöcke für diese Cmdlets nutzen `$_`, nicht `param`.

## Beispiel

```powershell
$IsStopped = { $_.Status -eq 'Stopped' }
$ToName = { $_.Name.ToUpper() }

$Services | Where-Object -FilterScript $IsStopped | ForEach-Object -Process $ToName
```
