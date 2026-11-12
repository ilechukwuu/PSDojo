# -match und $Matches

Ein regulärer Ausdruck, kurz Regex, ist ein Muster, das Text beschreibt. `-match` prüft, ob
ein Text etwas enthält, das auf das Muster passt, und antwortet mit wahr oder falsch.

Die Bausteine, die du zuerst brauchst:

- Gewöhnliche Zeichen stehen für sich selbst: `ERROR` passt auf das Wort ERROR.
- `\d` ist eine beliebige Ziffer, `\w` ein Buchstabe, eine Ziffer oder ein Unterstrich, `\s`
  Leerraum.
- `+` nach etwas bedeutet ein- oder mehrmals. `\d+` ist eine ganze Zahl.
- `{2}` bedeutet genau zweimal. `\d{2}` sind zwei Ziffern.
- Runde Klammern fangen den Teil, den sie umschließen.

Nach einem erfolgreichen Treffer enthält die automatische Variable `$Matches`, was gefunden
wurde: `$Matches[0]` ist der ganze Treffer, `$Matches[1]` der erste gefangene Teil,
`$Matches[2]` der zweite.

`$Matches` wird nur bei einem erfolgreichen Treffer aktualisiert. Prüfe immer das Ergebnis
von `-match`, bevor du es liest.

## Beispiel

```powershell
$Line = 'Disk D: on FS-02 is 91 percent full'

if ($Line -match 'on (FS-\d+) is (\d+) percent') {
    $Server = $Matches[1]
    $Percent = [int]$Matches[2]
}
```

`$Server` ist FS-02 und `$Percent` ist die Zahl 91.
