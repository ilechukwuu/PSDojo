# Die Reihenfolge in einem Skript

PowerShell liest ein Skript von oben nach unten und führt jede Anweisung aus, wenn es sie
erreicht. Daraus folgen drei Regeln.

**`param` kommt zuerst.** Über dem `param`-Block dürfen nur Kommentare und `#Requires`-Zeilen
stehen. Eine Anweisung davor ist ein Syntaxfehler, und das Skript läuft gar nicht.

**Erst definieren, dann benutzen.** Eine `function`-Anweisung erzeugt die Funktion in dem
Moment, in dem sie ausgeführt wird. Ein Aufruf weiter oben in der Datei scheitert mit "Die
Benennung ... wurde nicht erkannt". Der übliche Aufbau ist deshalb: `param`-Block, dann alle
Funktionen, dann der Hauptteil, der sie aufruft.

**Eine Funktion zählt in ihrem eigenen Bereich.** Ein Zähler, den eine Funktion erhöhen soll,
braucht das Präfix `$script:`, oder besser, die Funktion gibt einen Wert zurück und der
Aufrufer zählt.

Die letzte Ausgabe eines Skripts kann ein Objekt sein, das das Ergebnis zusammenfasst. Der
Aufrufer erhält es und kann mit seinen Eigenschaften arbeiten.

## Beispiel

```powershell
param([string[]]$ComputerName)

function Test-Name {
    param($Name)
    $script:Checked = $script:Checked + 1
    $Name -like 'FS-*'
}

$Checked = 0
$FileServers = $ComputerName | Where-Object { Test-Name -Name $_ }

[pscustomobject]@{ Checked = $Checked; FileServers = $FileServers }
```
