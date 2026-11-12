# Daten als Text

Ein Datumsobjekt hat keinen Aufbau. Erst wenn es zu Text wird, muss jemand zwischen
14.03.2026, 3/14/2026 und 2026-03-14 entscheiden. Entscheidest du nicht, tut es die Sprache
des Systems, und dasselbe Skript schreibt auf zwei Servern unterschiedliche Texte.

**Schreiben.** `ToString` mit einem Aufbau liefert immer denselben Text. Die Buchstaben
unterscheiden Groß- und Kleinschreibung:

- `yyyy` Jahr, `MM` Monat, `dd` Tag
- `HH` Stunde im 24-Stunden-Format, `mm` Minute, `ss` Sekunde

Kleines `mm` sind Minuten, großes `MM` sind Monate. Nutze für Dateinamen und Logs
`yyyy-MM-dd` oder `yyyyMMdd-HHmm`: Solche Namen sortieren sich von selbst richtig.

**Lesen.** Ein Cast mit `[datetime]` versteht nur Jahr-Monat-Tag sicher. Sage bei jedem
anderen Aufbau genau, was du erwartest:
`[datetime]::ParseExact('14.03.2026', 'dd.MM.yyyy', $null)`. Passt der Text nicht, bekommst
du einen Fehler statt eines falschen Datums.

## Beispiel

```powershell
$Now = Get-Date
$Now.ToString('yyyy-MM-dd')
$Now.ToString('yyyyMMdd-HHmm')

[datetime]::ParseExact('14.03.2026', 'dd.MM.yyyy', $null)
```

Die letzte Zeile liefert ein echtes Datumsobjekt für den 14. März 2026.
