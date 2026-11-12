# Die Zeile beschreiben, nicht Wörter zählen

Ein verbreiteter Weg, eine Logzeile zu zerlegen: an den Leerzeichen trennen und Wörter über
ihre Position holen. Das dritte Wort ist die Stufe, das achte der Server. Das funktioniert
für die Zeile, mit der du getestet hast. Es bricht ohne Fehler, sobald eine Zeile ein Wort
mehr oder weniger hat, und das haben Logzeilen.

Ein regulärer Ausdruck mit benannten Gruppen beschreibt, was du suchst, statt wo es zufällig
steht:

- Das Datum sind vier Ziffern, ein Bindestrich, zwei Ziffern, ein Bindestrich, zwei Ziffern
  am Anfang,
- die Stufe ist das Wort nach der Uhrzeit,
- der Server folgt dem Wort `on`,
- die Zahl steht vor `percent`.

Wörter dazwischen deckt `.*` ab, das heißt beliebige Zeichen, so viele wie nötig.

Benenne jede Gruppe. `$Matches.Server` dokumentiert sich selbst, und eine später ergänzte
Gruppe verschiebt die Nummern der anderen nicht.

## Beispiel

```powershell
$Pattern = '^(?<Date>\d{4}-\d{2}-\d{2}) \S+ (?<Level>\w+) .* on (?<Server>FS-\d+)'

if ($Line -match $Pattern) {
    $Matches.Date
    $Matches.Level
    $Matches.Server
}
```

`\S+` ist eine Folge von Nicht-Leerzeichen, hier die Uhrzeit.
