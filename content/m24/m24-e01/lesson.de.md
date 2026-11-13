# Skriptblöcke

Skriptblöcke schreibst du seit den Pipeline-Modulen: Die geschweiften Klammern nach
`Where-Object` sind einer. Ein Skriptblock ist ein Stück Code als Wert. Er lässt sich in
einer Variablen speichern, an einen Befehl übergeben und später ausführen, so oft wie nötig.

**Definieren führt ihn nicht aus.** `$Block = { Get-Date }` speichert den Code. Noch passiert
nichts.

**Der Aufrufoperator führt ihn aus.** `& $Block` führt den Code aus und liefert seine
Ausgabe.

**`param` gibt ihm Eingaben.** Ein Skriptblock kann wie ein Skript mit einem `param`-Block
beginnen. Der Aufrufer übergibt die Werte nach dem Block, über die Position oder den Namen.

Alles, was ein Skriptblock ausgibt, ist sein Ergebnis, genau wie bei einem Skript.

So wird aus einer Rechnung, die du an mehreren Stellen brauchst, eine einzige Definition.
Ändert sich die Regel, änderst du eine Zeile.

## Beispiel

```powershell
$ToPercent = {
    param($Part, $Total)
    [math]::Round($Part / $Total * 100, 1)
}

& $ToPercent 18 240
& $ToPercent -Part 51 -Total 60
```

Die Ergebnisse sind 7.5 und 85.
