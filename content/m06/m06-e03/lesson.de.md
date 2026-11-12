# Methoden

Eine Methode ist etwas, das ein Objekt tun kann. Du rufst sie auf wie eine Eigenschaft, aber
mit runden Klammern hinter dem Namen. Die Klammern sind Pflicht, auch wenn sie leer bleiben.
Argumente stehen darin, getrennt durch Kommas.

Methoden, die du jede Woche brauchst:

- Bei Text: `ToUpper()`, `ToLower()`, `Trim()`, `Replace('alt', 'neu')`, `Split('.')`,
  `StartsWith('FS')`.
- Bei Datumswerten: `AddDays(30)`, `AddHours(-2)`, `ToString('yyyy-MM-dd')`.

Zwei Regeln ersparen dir Überraschungen.

Methoden von Text und Datum liefern einen neuen Wert. Das Original bleibt, wie es war. Willst
du das Ergebnis behalten, musst du es speichern.

Methodennamen unterscheiden keine Groß- und Kleinschreibung, das, was sie vergleichen, meist
schon: `Replace` und `StartsWith` behandeln `fs` und `FS` als verschieden.

Das Ergebnis einer Methode ist wieder ein Objekt, du kannst also mit einem weiteren Punkt
fortfahren.

## Beispiel

```powershell
$Server = 'FS-02.nordwind.example'
$Server.ToLower()
$Server.Split('.')[0]
(Get-Date -Year 2026 -Month 3 -Day 14).AddDays(30).Month
```

Zeile 3 trennt an den Punkten und nimmt den ersten Teil, FS-02. Zeile 4 addiert dreißig Tage
und liest den Monat, 4.
