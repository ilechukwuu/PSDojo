# Musterfehler

Ein zu lockeres Muster ist die gefährliche Art von Fehler: Es passt auf das, worauf es passen
soll, besteht jeden schnellen Test und passt außerdem auf Dinge, an die niemand gedacht hat.

**Keine Anker.** Eine Prüfung wie `-match 'FS-\d\d'` akzeptiert jeden Text, der irgendwo
einen Servernamen enthält. Prüfen heißt der ganze Text: `'^FS-\d\d$'`.

**Ein unmaskierter Punkt.** `'nordwind.example'` akzeptiert jedes Zeichen zwischen den zwei
Wörtern. Maskiere ihn: `'nordwind\.example'`.

**Der Ersatz in doppelten Anführungszeichen.** `"$2 $1"` wird von PowerShell ausgefüllt,
bevor `-replace` läuft. Die Gruppen werden nie benutzt, und der Text kommt leer oder falsch
heraus.

Um ein Muster zu testen, probiere nicht nur die Texte, auf die es passen soll. Probiere
mindestens einen, der ähnlich aussieht und nicht passen darf. Diese zweite Art von Test
findet diese Fehler.

`[regex]::Escape('web.nordwind.example')` liefert den Text mit jedem Sonderzeichen maskiert,
fertig für die Verwendung als wörtliches Muster.

## Beispiel

```powershell
'XFS-021' -match '^FS-\d\d$'
'fs-02.nordwindXexample' -match 'nordwind\.example$'
'Keller, Anna' -replace '^(\w+), (\w+)$', '$2 $1'
```

Die Ergebnisse sind False, False und Anna Keller.
