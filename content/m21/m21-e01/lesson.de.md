# CSV

CSV ist das Format von Tabellenkalkulationen und Exporten: eine Zeile pro Datensatz, die
Werte durch ein Zeichen getrennt, in der ersten Zeile die Spaltennamen.

`Import-Csv` liest eine solche Datei und liefert ein Objekt pro Zeile. Die Spaltennamen
werden zu Eigenschaftsnamen. Ab da gilt alles, was du über Objekte weißt.

Zwei Dinge machen den meisten Ärger:

- **Alles ist Text.** Eine Spalte mit Zahlen kommt als Texte an. Wandle mit `[int]` um, bevor
  du vergleichst oder rechnest.
- **Das Trennzeichen.** Standard ist ein Komma. Excel auf einem deutschen System schreibt
  Semikolons. Nenne es mit `-Delimiter ';'`, beim Lesen und beim Schreiben.

`Export-Csv` schreibt Objekte in eine Datei, eine Spalte pro Eigenschaft. Windows PowerShell
5.1 setzt eine Zeile mit `#TYPE` an den Anfang, wenn du nicht `-NoTypeInformation` angibst.
PowerShell 7 lässt sie von selbst weg. Mit dem Schalter verhalten sich beide gleich.
`-Encoding UTF8` erhält Umlaute.

## Beispiel

```powershell
$Rows = Import-Csv -Path D:\Reports\disks.csv -Delimiter ';'
$Low = $Rows | Where-Object { [int]$_.FreeGB -lt 20 }
$Low | Export-Csv -Path D:\Reports\low.csv -Delimiter ';' -NoTypeInformation -Encoding UTF8
```
