# Ein Aufruf für die ganze Liste

Hast du mehrere Namen, ist die erste Idee oft, den Befehl einmal pro Name aufzurufen und die
Ergebnisse zu sammeln. Das funktioniert, ist aber langsam und lang, und gegen einen
entfernten Server ist jeder Aufruf ein eigener Hin- und Rückweg.

Schau zuerst auf den Typ in der Syntax. `-Name <string[]>` endet mit `[]`, der Parameter
nimmt also die ganze Liste auf einmal. Es gibt zwei gleich gute Wege, sie zu übergeben:

- Als Parameterwert: `Get-Process -Name $Names`
- Durch die Pipe, wenn der Parameter Pipeline-Eingabe annimmt: `$Rows | Get-Process`

In beiden Fällen läuft der Befehl einmal und liefert alles zusammen.

Einen Befehl für jedes Element einzeln aufzurufen ist nur richtig, wenn der Parameter einen
einzelnen Wert nimmt oder jedes Element anders behandelt werden muss. Modul 19 behandelt
Schleifen.

## Beispiel

```powershell
$a = Get-Process -Name spoolsv
$b = Get-Process -Name lsass
$All = $a, $b

$Names = 'spoolsv', 'lsass'
$All = Get-Process -Name $Names
```

Die Zeilen 1 bis 3 fragen zweimal. Zeile 6 fragt einmal und liefert dieselben zwei Prozesse.
