# Ein Text statt vieler Stücke

Einen Text aus Stücken mit `+` zu bauen funktioniert, und wer aus anderen Sprachen kommt, tut
es aus Gewohnheit. Es hat drei Nachteile.

- Es ist schwer zu lesen. Der Satz wird von Anführungszeichen und Pluszeichen zerhackt, und
  fehlende Leerzeichen zwischen den Stücken übersieht man leicht.
- Es ist zerbrechlich. Ist das erste Stück eine Zahl, beginnt `+` zu rechnen, und die Zeile
  scheitert.
- Es ist lang.

PowerShell bietet zwei bessere Formen.

**Einsetzen** in doppelten Anführungszeichen für einfache Fälle:
`"Server $Name has $Free GB free"`. Der Satz lässt sich als Satz lesen.

**Der Formatoperator**, wenn Werte formatiert werden müssen oder derselbe Wert mehrfach
vorkommt: `'{0} has {1} GB free' -f $Name, $Free`.

Wähle eine der beiden, und das Ergebnis ist kürzer und liest sich so, wie die Ausgabe
aussehen wird.

## Beispiel

```powershell
$Line = 'Server ' + $Name + ' has ' + $Free + ' GB free'

$Line = "Server $Name has $Free GB free"
$Line = 'Server {0} has {1} GB free' -f $Name, $Free
```

Alle drei ergeben denselben Text. In den Zeilen 3 und 4 sieht man ihn.
