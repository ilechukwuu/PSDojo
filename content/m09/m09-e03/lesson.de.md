# Wissen, was fließt

Nach `Sort-Object` und `Where-Object` kommen dieselben Objekte heraus, die hineingingen. Nach
`Select-Object`, `Group-Object` und `Measure-Object` kommt etwas anderes heraus, und der
nächste Befehl muss damit arbeiten.

- Nach `Select-Object -Property Name` hast du Objekte mit einer Eigenschaft. Als Text
  zusammengefügt ergeben sie `@{Name=Spooler}`, nicht `Spooler`.
- Nach `Select-Object -ExpandProperty Name` hast du reine Texte. Sie haben keine Eigenschaft
  `Name` mehr, sie sind die Namen.
- Nach `Group-Object` hast du Gruppenobjekte. Sortieren nach `Count` sortiert die Gruppen,
  und `Name` ist der Wert, nach dem gruppiert wurde.
- Nach `Measure-Object` hast du genau ein Objekt, egal wie viele hineingingen.

Bist du unsicher, leite das Zwischenergebnis in `Get-Member` und lies oben den Typnamen.

## Beispiel

```powershell
Get-Service | Group-Object -Property Status | Sort-Object -Property Count -Descending |
    Select-Object -First 1 -ExpandProperty Name
```

Nach Status gruppieren, die größte Gruppe nach vorn, eine behalten und ihren Namen als Text
liefern: der Status, der am häufigsten vorkommt.
