# Typische Fehler

**Der fehlende Aufrufoperator.** Eine Variable gefolgt von einem Wert ist kein Befehl.
`$GetStatus $Volume` ist ein Syntaxfehler, und `$GetStatus` allein gibt nur den Code als Text
aus. Einen Block auszuführen braucht immer `&` davor.

**`$_` an der falschen Stelle.** `$_` wird von der Pipeline gesetzt: von `Where-Object`,
`ForEach-Object` und ähnlichen Cmdlets. Ein Block, den du selbst mit `& $Block $Value`
aufrufst, hat kein aktuelles Pipeline-Objekt. Dort ist `$_` leer, jede darauf gelesene
Eigenschaft ebenfalls, und ein Vergleich mit einer Zahl ist still für alle Eingaben wahr oder
falsch. Ein solcher Block braucht `param`.

**Runde statt geschweifter Klammern.** `Where-Object ($_.Size -gt 10)` berechnet den
Vergleich einmal, sofort, und übergibt das Ergebnis an das Cmdlet. `Where-Object` erwartet
Code, das endet also in einem Fehler über einen Wert, der sich nicht in einen Skriptblock
umwandeln lässt. Ein Filter steht in geschweiften Klammern.

Die Faustregel: Geschweifte Klammern heissen "später", runde heissen "jetzt".

## Beispiel

```powershell
$GetSizeClass = {
    param($File)
    if ($File.Length -gt 1GB) { 'large' } else { 'normal' }
}

$Classes = foreach ($File in $Files) { & $GetSizeClass $File }
$Large = $Files | Where-Object { $_.Length -gt 1GB }
```
