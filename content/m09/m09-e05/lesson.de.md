# Typische Fehler mit Select-Object

Drei Fehler erklären die meisten kaputten Berichte.

**Eine Eigenschaft benutzen, die nicht ausgewählt wurde.** Alles nach
`Select-Object -Property` sieht nur die neuen, schmalen Objekte. Wer nach einer
weggelassenen Eigenschaft sortiert oder filtert, sortiert oder filtert nach nichts, ohne
Fehler. Erledige diese Arbeit vor dem Auswählen oder nutze die neue Eigenschaft.

**Ein Ausdruck ohne Klammern.** `Expression = $_.WorkingSet64 / 1MB` wird sofort berechnet,
während `$_` noch leer ist. PowerShell beschwert sich dann, dass der Schlüssel Expression
einen ungültigen Wert hat. Der Wert muss ein Skriptblock sein: `Expression = { ... }`.

**Objekte, wo Text gewünscht war.** `Select-Object -Property Name` liefert Objekte. Zu einem
Text zusammengefügt sehen sie aus wie `@{Name=excel}`. Für eine reine Werteliste nimm
`-ExpandProperty`.

## Beispiel

```powershell
Get-Process | Select-Object -Property Name | Sort-Object -Property WorkingSet64

Get-Process | Sort-Object -Property WorkingSet64 | Select-Object -Property Name
```

Zeile 1 sortiert nach einer Eigenschaft, die es nicht mehr gibt, die Reihenfolge ist
bedeutungslos. Zeile 3 sortiert zuerst und wählt danach aus.
