# Schleifen auf PowerShell-Art

Wer zuerst eine andere Sprache gelernt hat, schreibt Schleifen so: ein Zähler von 0 bis zur
Länge, das Element über seine Position geholt und jedes Ergebnis mit `+=` an ein Array
angehängt.

Das funktioniert, und es hat drei Schwächen.

- Der Zähler ist eine Quelle für Off-by-one-Fehler und bringt nichts, wenn du nur das Element
  brauchst.
- `$Servers[$i]` verdeckt, worum es im Code geht.
- `+=` baut in jedem Durchlauf ein neues Array. Bei vielen Elementen wird das langsam.

Die PowerShell-Art beseitigt alle drei:

- `foreach ($Server in $Servers)` gibt dir das Element direkt.
- Was der Block erzeugt, sammelt die Schleife selbst. Weise die ganze Schleife der Variablen
  zu.

Behalte `for` für die Fälle, in denen die Position selbst zählt, etwa wenn zwei Listen
parallel gelesen werden.

## Beispiel

```powershell
$Lines = @()
for ($i = 0; $i -lt $Servers.Count; $i++) {
    $Lines += "Checking $($Servers[$i])"
}

$Lines = foreach ($Server in $Servers) {
    "Checking $Server"
}
```

Beide ergeben dasselbe Array. Die zweite Fassung hat keinen Zähler, keinen Index und kein
`+=`.
