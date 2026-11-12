# Gezielt umwandeln

Statt zu hoffen, dass PowerShell richtig umwandelt, sage, was du willst. Ein Typ in eckigen
Klammern vor einem Wert wandelt ihn um. Das nennt man Cast.

- `[int]'81'` ergibt die Zahl 81.
- `[double]'81.5'` ergibt 81.5.
- `[datetime]'2026-03-14'` ergibt ein Datum. Schreibe Daten als Jahr-Monat-Tag, dieses
  Format wird überall verstanden, egal in welcher Sprache das System läuft.
- `[string]445` ergibt den Text 445.

Ist die Umwandlung unmöglich, etwa bei `[int]'twelve'`, gibt es sofort einen Fehler. Das ist
gut: Das Skript hält dort an, wo die schlechten Daten sind, nicht drei Schritte später.

Ein Typ vor dem Variablennamen geht weiter. `[int]$Count = '12'` wandelt jetzt um und sorgt
dafür, dass die Variable diesen Typ behält. Alles, was ihr später zugewiesen wird, wird
ebenfalls umgewandelt oder abgelehnt.

## Beispiel

```powershell
$UsedText = '81'
$Used = [int]$UsedText
$Used + 1

[datetime]$Start = '2026-03-14'
$Start.AddDays(7)
```

Zeile 3 liefert 82. Zeile 6 kann rechnen, weil `$Start` ein echtes Datum ist.
