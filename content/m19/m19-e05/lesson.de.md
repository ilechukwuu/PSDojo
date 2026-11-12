# Schleifenfehler

**Die Liste statt des Elements.** In `foreach ($Server in $Servers)` benutzt der Block
`$Servers`, mit s. Jeder Durchlauf arbeitet dann mit der ganzen Liste. Ein Buchstabe, und der
Editor kann nicht warnen, weil es beide Variablen gibt.

**Ein Durchlauf zu viel.** `for ($i = 0; $i -le $Servers.Count; $i++)` läuft einmal öfter,
als es Elemente gibt, weil Positionen bei 0 beginnen. Der zusätzliche Durchlauf liest ein
Element, das es nicht gibt, und bekommt `$null`. Die richtige Bedingung ist `-lt`.

**break, wo continue gemeint war.** Um ein Element zu überspringen, macht `continue` mit dem
nächsten weiter. `break` beendet die ganze Schleife, und alles nach diesem Element wird still
weggelassen.

Alle drei erzeugen plausibel aussehende Ausgaben. Zähle die Ergebnisse: Liefert eine Schleife
über vier Server fünf Zeilen oder zwei, stimmt etwas mit der Schleife selbst nicht.

## Beispiel

```powershell
foreach ($Server in $Servers) {
    if ($Server -eq 'FS-02') { continue }
    "Patching $Server"
}
```

FS-02 wird übersprungen, und die Schleife macht mit dem nächsten Server weiter. Mit `break`
würden die Server nach FS-02 nie gepatcht.
