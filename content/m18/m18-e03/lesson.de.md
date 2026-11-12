# switch

Entscheidet ein Wert zwischen vielen Möglichkeiten, wird eine Kette von `elseif` lang und
wiederholt die Variable in jeder Zeile. Dafür gibt es `switch`.

Der Wert steht in runden Klammern. In den geschweiften Klammern ist jeder Fall ein Wert,
gefolgt von einem Block. PowerShell vergleicht den Wert mit jedem Fall und führt die Blöcke
aus, die passen. `default` läuft, wenn kein Fall gepasst hat.

Wie `if` liefert ein `switch`, was seine Blöcke erzeugen, und lässt sich deshalb einer
Variablen zuweisen.

Zwei Optionen ändern, wie Fälle verglichen werden:

- `-Wildcard` erlaubt `*` und `?` in einem Fall.
- `-Regex` behandelt Fälle als reguläre Ausdrücke.

Verglichen wird ohne Rücksicht auf Groß- und Kleinschreibung, außer mit `-CaseSensitive`.

Ein Unterschied zu `if`: Nach einem Treffer prüft `switch` die übrigen Fälle weiter. Es kann
mehr als ein Block laufen. `break` in einem Block beendet das.

## Beispiel

```powershell
$Action = switch ($Status) {
    'Running' { 'Nothing to do' }
    'Stopped' { 'Start the service' }
    default   { 'Check by hand' }
}

$Role = switch -Wildcard ($Server) {
    'FS-*'  { 'File server' }
    'PRN-*' { 'Print server' }
    default { 'Other' }
}
```
