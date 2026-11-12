# Was in der Produktion schiefgeht

Ein nächtlicher Job soll die Liste gesperrter Konten als CSV-Datei für den Service Desk
speichern:

```powershell
Search-ADAccount -LockedOut | Format-Table -Property Name, LockedOut | Export-Csv -Path locked.csv
```

Am Morgen ist die Datei voller Spalten mit Namen wie ClassId2e4f51ef21dd47e99d3c952918aff9cd
und pageHeaderEntry. `Format-Table` hatte die Konten bereits in Layoutanweisungen für den
Bildschirm verwandelt, und `Export-Csv` hat diese getreu exportiert.

`Format-`Cmdlets sind nur für menschliche Augen. Sie gehören ganz ans Ende einer Pipeline,
und nichts, was Daten braucht, darf nach ihnen kommen. Für Dateien, die ein Programm liest,
wähle Eigenschaften mit `Select-Object` aus und formatiere gar nicht.
