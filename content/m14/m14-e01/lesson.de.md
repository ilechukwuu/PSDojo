# Zwei Arten von Anführungszeichen

PowerShell hat zwei Arten von Anführungszeichen, und sie verhalten sich unterschiedlich.

**Einfache Anführungszeichen** nehmen jedes Zeichen wörtlich. `'Costs $5'` ist genau dieser
Text. Nutze sie immer, wenn nichts eingesetzt werden muss. Sie sind der sichere Standard.

**Doppelte Anführungszeichen** suchen nach `$` und ersetzen, was folgt.

- Eine Variable wird durch ihren Wert ersetzt: `"Server $Name"`.
- Alles, was mehr ist als eine einfache Variable, eine Eigenschaft, ein Methodenaufruf, eine
  Rechnung, kommt in `$( )`. PowerShell wertet den Inhalt aus und setzt das Ergebnis ein:
  `"Free: $($Disk.FreeGB) GB"`.
- Folgt dem Variablennamen direkt ein Buchstabe, eine Ziffer oder ein Unterstrich, weiß
  PowerShell nicht, wo der Name endet. Geschweifte Klammern markieren ihn:
  `"${Name}_backup"`.

Für ein echtes Dollarzeichen oder ein doppeltes Anführungszeichen innerhalb doppelter
Anführungszeichen setzt du einen Backtick davor.

## Beispiel

```powershell
$Name = 'FS-02'
$Disk = [pscustomobject]@{ FreeGB = 75 }

'Server $Name'
"Server $Name"
"Free: $($Disk.FreeGB) GB"
"${Name}_backup.zip"
```

Zeile 4 gibt das Dollarzeichen und das Wort aus. Die Zeilen 5 bis 7 geben Server FS-02,
Free: 75 GB und FS-02_backup.zip aus.
