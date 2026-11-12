# Berechnete Eigenschaften

Objekte tragen selten genau die Werte, die ein Bericht braucht. Größen stehen in Bytes, eine
Spalte heißt falsch, aus zwei Eigenschaften soll eine werden. `Select-Object` kann unterwegs
neue Eigenschaften erzeugen. Eine solche Eigenschaft steht in der Liste nach `-Property`
zwischen den anderen:

`@{ Name = 'MemoryMB'; Expression = { $_.WorkingSet64 / 1MB } }`

- `Name` ist der Name der neuen Eigenschaft.
- `Expression` ist ein Skriptblock in geschweiften Klammern, der den Wert berechnet. Darin
  ist `$_` das aktuelle Objekt, genau wie in `Where-Object`.

Die Klammern um den Ausdruck sind entscheidend. Ohne sie rechnet PowerShell einmal, sofort,
bevor irgendein Objekt angekommen ist.

Eine berechnete Eigenschaft ist auch der Weg zum Umbenennen: Der Ausdruck liefert einfach die
alte Eigenschaft unter neuem Namen. So binden Daten an einen Parameter, der anders heißt.

## Beispiel

```powershell
Get-Process | Select-Object -Property Name,
    @{ Name = 'MemoryMB'; Expression = { [math]::Round($_.WorkingSet64 / 1MB) } },
    @{ Name = 'ProcessId'; Expression = { $_.Id } }
```

Jedes Ergebnis hat drei Eigenschaften: den Namen, den Speicher in Megabyte und die Id unter
neuem Namen.
