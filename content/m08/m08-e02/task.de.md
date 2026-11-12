# Aufgabe

Ein Datenträgerbericht für die Dateiserver verhält sich merkwürdig. Du verdächtigst seine
Vergleiche. Sage vorher, was jede Zeile liefert, und speichere `$true` oder `$false`. Führe
die Zeilen nicht aus.

```powershell
'PRN-01' -eq 'prn-01'
'100' -gt '25'
100 -gt '25'
'FS-02.nordwind.example' -eq 'FS-02*'
'FS-02.nordwind.example' -like 'FS-0?.*'
'C:', 'D:' -contains 'd:'
```

Speichere die sechs Ergebnisse in `$Result1` bis `$Result6`, in der Reihenfolge der Zeilen.
