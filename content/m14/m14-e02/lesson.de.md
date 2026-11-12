# Wie das Ersetzen wirklich funktioniert

Trifft PowerShell in doppelten Anführungszeichen auf ein `$`, liest es weiter, solange die
Zeichen zu einem Variablennamen gehören können: Buchstaben, Ziffern und der Unterstrich. Was
es dann hat, wird nachgeschlagen.

Drei Folgen:

- Ein Punkt beendet den Namen. `"$Disk.FreeGB"` ersetzt `$Disk` und lässt `.FreeGB` als
  reinen Text stehen. Ein eigenes Objekt sieht als Text aus wie `@{FreeGB=75}`.
- Ein Unterstrich beendet den Namen nicht. `"$Server_backup"` sucht eine Variable namens
  `Server_backup`.
- Eine Variable, die es nicht gibt, wird durch nichts ersetzt, ohne Fehler.

Auch ein Doppelpunkt ist besonders: `"$Drive: full"` wird als Name mit Laufwerk gelesen, wie
`$env:PATH`. Schreibe `"${Drive}: full"`.

Kommt ein Text falsch heraus, suche genau diese Stellen: einen Punkt, einen Unterstrich oder
einen Doppelpunkt direkt nach einer Variablen.

## Beispiel

```powershell
$Server = 'FS-02'
"$Server.nordwind.example"
"$Server_old"
"$($Server.Length) characters"
```

Zeile 2 ergibt FS-02.nordwind.example, was hier gewollt war. Zeile 3 ergibt einen leeren
Text. Zeile 4 ergibt 5 characters.
