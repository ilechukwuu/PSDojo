# Arrays

Ein Array ist eine Liste von Werten in fester Reihenfolge. Du benutzt Arrays schon die ganze
Zeit: Jeder Befehl, der mehrere Objekte liefert, liefert ein Array.

Du legst eines an, indem du Werte durch Kommas trennst. `@()` darum ist optional, macht aber
die Absicht klar, und `@()` allein ist ein leeres Array.

Jedes Element hat eine Position, den Index, und gezählt wird ab 0.

- `$Servers[0]` ist das erste Element.
- `$Servers[-1]` ist das letzte, `[-2]` das davor. Negative Zahlen zählen vom Ende.
- `$Servers[1..2]` ist ein Ausschnitt: die Elemente an den Positionen 1 und 2, wieder als
  Array.
- `$Servers.Count` ist die Anzahl der Elemente.

Fragst du nach einer Position, die es nicht gibt, kommt `$null` zurück und kein Fehler.

## Beispiel

```powershell
$Servers = 'FS-01', 'FS-02', 'FS-03', 'FS-04'
$Servers[0]
$Servers[-1]
$Servers[1..2]
$Servers.Count
```

Die Ergebnisse sind FS-01, FS-04, die zwei Server FS-02 und FS-03 und 4.
