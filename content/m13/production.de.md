# Was in der Produktion schiefgeht

Ein Überwachungsskript soll Alarm schlagen, wenn ein Datenträger zu mehr als 90 Prozent voll
ist. Der Autor kommt aus einer anderen Sprache:

```powershell
if ($UsedPercent > 90) { Send-Alarm }
```

In PowerShell ist `>` nicht "größer als". Es leitet Ausgabe in eine Datei um. Das Skript legt
bei jedem Lauf eine Datei namens 90 im aktuellen Ordner an, die Bedingung ist immer wahr, und
das Bereitschaftstelefon klingelt alle fünf Minuten für jeden Datenträger der Firma.

Vergleichsoperatoren beginnen in PowerShell mit einem Bindestrich: `-gt`, `-lt`, `-eq`.
Verhält sich eine Bedingung merkwürdig, prüfe zuerst die Operatoren.
