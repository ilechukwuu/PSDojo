# Aufgabe

Ein Kapazitätsbericht zeigt den vollsten Server ganz unten und eine absurde Summe. Die Daten
stammen aus dieser CSV-Datei:

```powershell
Server,FreeGB
FS-01,100
FS-02,20
FS-03,9
```

Und aus diesem JSON-Text: `{ "name": "FS-01", "freeGB": 100, "label": "100" }`

Sage die Ergebnisse vorher. Führe nichts aus. `$Rows` ist das Ergebnis von `Import-Csv`,
`$Item` das Ergebnis von `ConvertFrom-Json`.

1. `($Rows | Sort-Object -Property FreeGB)[0].Server` Speichere den Server in `$Result1`.
2. `($Rows | Sort-Object -Property { [int]$_.FreeGB })[0].Server` Speichere ihn in
   `$Result2`.
3. `$Rows[0].FreeGB + $Rows[1].FreeGB` Speichere das Ergebnis mit seinem echten Typ in
   `$Result3`.
4. `($Rows | Measure-Object -Property FreeGB -Sum).Sum` Speichere die Zahl in `$Result4`.
5. `$Item.freeGB + $Item.freeGB` Speichere das Ergebnis mit seinem echten Typ in `$Result5`.
