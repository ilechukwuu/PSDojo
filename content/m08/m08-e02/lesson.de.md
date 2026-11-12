# Wie Vergleiche entscheiden

Jeder Vergleich liefert `$true` oder `$false`. Vier Regeln erklären die meisten
Überraschungen.

**Schreibweise.** `-eq` und die anderen Operatoren ignorieren Groß- und Kleinschreibung. Ein
`c` davor macht sie genau: `-ceq`, `-clike`.

**Die linke Seite bestimmt den Typ.** Ist der linke Wert eine Zahl, wird der rechte in eine
Zahl umgewandelt. Ist der linke Wert Text, werden beide als Text verglichen, Zeichen für
Zeichen. Als Text kommt `'10'` vor `'9'`, weil 1 vor 9 kommt.

**Platzhalter brauchen -like.** `*` steht für beliebige Zeichen, `?` für genau eines. Bei
`-eq` ist ein Stern nur ein Stern.

**Listen.** `-contains` fragt, ob eine Liste links einen Wert enthält. `-in` fragt dasselbe
andersherum, mit dem Wert links.

`-match` vergleicht mit einem regulären Ausdruck. Das behandelt Modul 20.

## Beispiel

```powershell
'FS-02' -eq 'fs-02'
'FS-02' -ceq 'fs-02'
10 -gt 9
'10' -gt '9'
'FS-02' -like 'FS-*'
'FS-02', 'FS-03' -contains 'FS-03'
```

Die Ergebnisse sind True, False, True, False, True, True.
