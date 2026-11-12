# Group-Object und Measure-Object

**Group-Object** sortiert Objekte nach dem Wert einer Eigenschaft auf Stapel. Für jeden
unterschiedlichen Wert bekommst du ein Gruppenobjekt mit drei Eigenschaften:

- `Name`: der Wert, für den die Gruppe steht.
- `Count`: wie viele Objekte darin liegen.
- `Group`: die Objekte selbst.

Das beantwortet Fragen wie "wie viele Dienste pro Status" in einer Zeile.

**Measure-Object** rechnet mit Zahlen. Nenne die Eigenschaft und was du willst: `-Sum`,
`-Average`, `-Maximum`, `-Minimum`. Das Ergebnis ist ein einzelnes Objekt mit gleichnamigen
Eigenschaften, dazu `Count`. Ohne Schalter zählt es nur.

Größen kommen in Bytes. Teilen durch `1MB` oder `1GB` macht daraus lesbare Zahlen, und
`[math]::Round()` entfernt die Nachkommastellen.

## Beispiel

```powershell
Get-Service | Group-Object -Property Status

$Memory = Get-Process | Measure-Object -Property WorkingSet64 -Sum -Maximum
[math]::Round($Memory.Sum / 1MB)
```

Zeile 1 liefert eine Gruppe pro Status mit ihrer Anzahl. Zeile 4 rechnet die Summe aller
Arbeitsspeicherwerte in Megabyte um.
