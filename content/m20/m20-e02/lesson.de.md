# Worauf ein Muster wirklich passt

Drei Eigenschaften regulärer Ausdrücke überraschen anfangs jeden.

**Ein Treffer irgendwo zählt.** `-match 'FS-\d'` ist für XFS-021-old wahr, weil das Muster
irgendwo darin vorkommt. Soll ein ganzer Text passen, verankere das Muster: `^` steht für den
Anfang, `$` für das Ende. `'^FS-\d{2}$'` passt auf FS-02 und auf nichts Längeres.

**Sonderzeichen.** Manche Zeichen haben eine Bedeutung: `.` ist ein beliebiges Zeichen, und
auch `*`, `+`, `?`, `(`, `)`, `[`, `{`, `^`, `$`, `|` und `\` sind besonders. Ist das Zeichen
selbst gemeint, setze einen Backslash davor: `\.` ist ein echter Punkt.

**Schreibweise.** `-match` ignoriert Groß- und Kleinschreibung, wie alle Vergleiche.
`-cmatch` ist die genaue Form.

`-replace` benutzt dieselben Muster. Es ersetzt jeden Treffer, nicht nur den ersten.

## Beispiel

```powershell
'XFS-021' -match 'FS-\d'
'XFS-021' -match '^FS-\d{2}$'
'nordwindXexample' -match 'nordwind.example'
'nordwindXexample' -match 'nordwind\.example'
'10.0.0.1' -replace '.', '-'
```

Die Ergebnisse sind True, False, True, False und `--------`: Der Punkt hat auf jedes Zeichen
gepasst.
