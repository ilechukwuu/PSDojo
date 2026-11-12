# Days, TotalDays und Monatsenden

Ein TimeSpan zerlegt eine Dauer in Teile: `Days`, `Hours`, `Minutes`, `Seconds`. Eine Spanne
von 36 Stunden hat `Days` 1 und `Hours` 12. Jeder Teil ist nur sein eigener Anteil.

Die `Total`-Eigenschaften sind die ganze Dauer in einer Einheit: `TotalDays` 1.5,
`TotalHours` 36, `TotalMinutes` 2160.

Sie zu verwechseln ist ein klassischer Fehler. Ein Skript, das `$Age.Hours -gt 24` prüft,
schlägt nie an, weil `Hours` nie mehr als 23 ist. Es müsste `TotalHours` prüfen.

`New-TimeSpan` erzeugt eine Spanne direkt, zum Beispiel `New-TimeSpan -Hours 36`.

**Monate** sind ungleich lang, deshalb hat `AddMonths` eine Regel: Hat der Zielmonat den Tag
nicht, ist das Ergebnis der letzte Tag dieses Monats. 31. Januar plus ein Monat ist der 28.
Februar, im Schaltjahr der 29.

`DayOfWeek` liefert den Wochentag auf Englisch, egal in welcher Sprache das System läuft.

## Beispiel

```powershell
$Span = New-TimeSpan -Hours 36
$Span.Days
$Span.Hours
$Span.TotalHours
([datetime]'2026-01-31').AddMonths(1)
```

Die Ergebnisse sind 1, 12, 36 und der 28. Februar 2026.
