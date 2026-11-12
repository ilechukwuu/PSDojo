# Weitere Operatoren

Fünf Operatoren, die nichts mit Rechnen zu tun haben und ständig gebraucht werden.

- `-split` zerschneidet einen Text an einem Trennzeichen in eine Liste.
  `'C:,D:,E:' -split ','` ergibt drei Texte.
- `-join` ist das Gegenteil. Es klebt eine Liste mit einem Trennzeichen dazwischen zusammen.
- `..` ist der Bereichsoperator. `1..5` ist die Liste 1, 2, 3, 4, 5.
- `-is` fragt, ob ein Wert einen bestimmten Typ hat, und antwortet mit wahr oder falsch.
- `-as` versucht, einen Wert in einen Typ umzuwandeln. Anders als ein Cast scheitert es
  nicht, wenn das unmöglich ist. Es liefert `$null`, und darauf kannst du prüfen.

`-as` ist das Werkzeug für Daten, denen du nicht traust. Ein Cast hält das Skript beim ersten
schlechten Wert an. Mit `-as` entscheidest du, was damit geschieht.

## Beispiel

```powershell
$Drives = 'C:,D:,E:' -split ','
$Drives -join ' | '
1..3
'42' -is [int]
'42' -as [int]
'n/a' -as [int]
```

Zeile 2 ergibt `C: | D: | E:`. Zeile 4 ist False, weil der Wert noch Text ist. Zeile 5 ergibt
die Zahl 42 und Zeile 6 ergibt `$null`.
