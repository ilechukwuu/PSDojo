# CSV nicht von Hand bauen

Eine CSV-Datei zu schreiben sieht trivial aus: die Werte mit einem Semikolon verbinden und
die Zeile schreiben. Das funktioniert, bis ein Wert selbst ein Semikolon, ein
Anführungszeichen oder einen Zeilenumbruch enthält. Eine Beschreibung wie `Archive; old`
verschiebt dann jede Spalte rechts von ihr, und wer die Datei liest, bekommt falsche Daten
ohne jeden Fehler.

Das CSV-Format hat dafür Regeln: Solche Werte kommen in Anführungszeichen, und
Anführungszeichen darin werden verdoppelt. `Export-Csv` kennt diese Regeln, und `Import-Csv`
liest das Ergebnis exakt zurück.

Das Muster ist deshalb immer dasselbe:

1. Baue Objekte mit den Eigenschaften, die Spalten werden sollen. `Select-Object` wählt und
   ordnet sie.
2. Leite sie in `Export-Csv`.

Dasselbe gilt für JSON und XML. Setze ein Datenformat nie aus Textstücken zusammen, wenn ein
Cmdlet es schreiben kann.

`ConvertTo-Csv` tut dasselbe wie `Export-Csv`, liefert aber die Zeilen, statt eine Datei zu
schreiben.

## Beispiel

```powershell
$Disks |
    Select-Object -Property Server, Note, FreeGB |
    Export-Csv -Path report.csv -Delimiter ';' -NoTypeInformation -Encoding UTF8
```
