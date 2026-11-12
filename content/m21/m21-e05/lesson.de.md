# Formatfehler

**Das falsche Trennzeichen.** Eine Datei mit Semikolons, ohne `-Delimiter` gelesen, hat eine
einzige Spalte, deren Name die ganze Kopfzeile ist, `Server;Drive;FreeGB`. Das Symptom: Die
erwarteten Eigenschaften sind leer, und es erscheint kein Fehler.

**Mit CSV-Text rechnen.** Eine Summe mit `+` fügt die Werte zusammen. Das Symptom: eine viel
zu große Zahl mit zu vielen Stellen.

**JSON ohne Tiefe.** Verschachtelte Teile werden zu einem Typnamen. Das Symptom: In der Datei
steht `System.Object[]` oder `@{...}`, wo Daten stehen sollten.

Alle drei haben etwas gemeinsam: Das Skript läuft bis zum Ende und schreibt eine Datei. Der
Fehler ist nur im Inhalt sichtbar.

Prüfe eine Datenstrecke deshalb an ihren Rändern. Sieh dir nach dem Lesen das erste Objekt
mit `Format-List -Property *` an. Lies nach dem Schreiben die Datei zurück und vergleiche
einen Wert, den du kennst.

## Beispiel

```powershell
$Rows = Import-Csv -Path disks.csv -Delimiter ';'
$Rows[0] | Format-List -Property *

$Total = ($Rows | Measure-Object -Property FreeGB -Sum).Sum
```

Zeile 2 zeigt auf einen Blick, ob die Spalten erkannt wurden.
