# Aufgabe

Ein Backup-Job für FS-02 begann am 14. März 2026 um 22:00 Uhr und endete am 16. März 2026 um
04:30 Uhr. Ein Kollege hat diese Zeilen für den Bericht geschrieben. Sage vorher, was sie
liefern. Führe nichts aus.

```powershell
$Start = [datetime]'2026-03-14T22:00:00'
$End = [datetime]'2026-03-16T04:30:00'
$Duration = $End - $Start

$Duration.Days
$Duration.Hours
$Duration.TotalHours
$Start.DayOfWeek
([datetime]'2026-03-31').AddMonths(1).Day
```

Speichere die Ergebnisse der Zeilen 5 bis 9 in `$Result1` bis `$Result5`. Speichere den
Wochentag als Text.
