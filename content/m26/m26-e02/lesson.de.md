# Validierungsattribute

Eine Funktion soll nicht mit Eingaben zu arbeiten beginnen, mit denen sie nicht umgehen kann.
Validierungsattribute prüfen einen Wert in dem Moment, in dem er an den Parameter gebunden
wird. Scheitert die Prüfung, bekommt der Aufrufer einen Fehler, der Parameter und Regel
nennt, und keine einzige Zeile deines Rumpfs ist gelaufen.

Die, die du am meisten brauchst:

- `[ValidateSet('Full', 'Log')]` erlaubt nur die gelisteten Werte. Als Zugabe bietet die
  Konsole sie mit der Tab-Taste an. Der Vergleich ignoriert Groß- und Kleinschreibung.
- `[ValidateRange(1, 90)]` erlaubt Zahlen von 1 bis 90, beide eingeschlossen.
- `[ValidatePattern('^FS-\d{2}$')]` verlangt einen Treffer des regulären Ausdrucks.
- `[ValidateNotNullOrEmpty()]` lehnt `$null`, einen leeren Text und eine leere Liste ab.
- `[ValidateLength(1, 15)]` begrenzt die Länge eines Textes.
- `[ValidateScript({ Test-Path -Path $_ })]` führt deine eigene Prüfung aus. `$_` ist der
  Wert.

Jede Regel, die du als Attribut ausdrückst, ist ein `if` mit handgeschriebener Fehlermeldung,
das du nicht schreiben, testen und richtig halten musst.

## Beispiel

```powershell
function Get-LogExtract {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Path,

        [ValidateSet('Error', 'Warning', 'Info')]
        [string]$Level = 'Error',

        [ValidateRange(1, 1000)]
        [int]$Last = 50
    )
}
```
