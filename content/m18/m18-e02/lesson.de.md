# Was als wahr zählt

Eine Bedingung muss kein Vergleich sein. In den Klammern kann jeder Wert stehen, und
PowerShell macht daraus nach festen Regeln wahr oder falsch.

Als **falsch** zählen:

- `$null`
- die Zahl 0
- ein leerer Text `''`
- ein leeres Array `@()`

Alles andere zählt als **wahr**: jede andere Zahl, jeder nicht leere Text, jedes Objekt,
jedes Array mit Elementen.

Das erlaubt kurze Prüfungen wie `if ($Result)` für "hat der Befehl etwas geliefert". Es
stellt auch Fallen:

- Der Text `'false'` ist wahr, weil er nicht leer ist. Der Text `'0'` ebenso.
- Ein Array mit dem einzigen Element 0 folgt seinem Element und ist falsch.
- Eine Anzahl von 0 ist falsch. `if ($Stopped.Count)` liest sich gut und funktioniert.

`-not` oder `!` kehrt einen Wert um: `if (-not $Result)` heißt "es kam nichts zurück".

## Beispiel

```powershell
if ('false') { 'runs' }
if (0) { 'does not run' }
if (@()) { 'does not run' }
if (-not $null) { 'runs' }
```

Die Zeilen 1 und 4 geben ihren Text aus, die Zeilen 2 und 3 nichts.
