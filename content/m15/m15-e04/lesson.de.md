# Datumsfehler

**Daten als Text vergleichen.** `'14.03.2026' -lt '02.04.2026'` vergleicht Zeichen für
Zeichen. Die 1 steht nach der 0, also sagt der Vergleich, das Märzdatum sei das spätere. Text
im Aufbau Tag-Monat-Jahr sortiert sich nicht nach der Zeit. Wandle zuerst beide Seiten in
Daten um.

**Ein deutsches Datum casten.** `[datetime]'14.03.2026'` scheitert, weil der Cast den Monat
zuerst liest und es keinen Monat 14 gibt. Schlimmer: `[datetime]'03.04.2026'` funktioniert
und ergibt den 4. März. Nutze `ParseExact`.

**Die falsche Richtung.** Ein Stichtag "vor 30 Tagen", geschrieben als `AddDays(30)`, liegt
in der Zukunft. Jedes Datum liegt dann vor dem Stichtag, und alles gilt als alt.

Prüfe eine Datumsrechnung mit einem Wert, den du von Hand nachrechnen kannst, bevor du ihr
tausend Konten anvertraust.

## Beispiel

```powershell
$Expires = [datetime]::ParseExact('03.04.2026', 'dd.MM.yyyy', $null)
$WarnFrom = $Expires.AddDays(-30)
$Today = [datetime]'2026-03-14'
$Today -ge $WarnFrom
```

Alle drei Werte sind echte Daten. Zeile 4 ist True: Die Warnfrist hat begonnen.
