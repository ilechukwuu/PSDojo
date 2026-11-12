# Filter, die schiefgehen

Ein falsch geschriebener Filter meldet oft keinen Fehler. Er liefert eine leere Liste oder
die falschen Objekte, und ein Skript, das mit dieser Liste arbeitet, tut still das Falsche.
Hinter den meisten Fällen stecken drei Fehler.

**= statt -eq.** `$_.Status = 'Stopped'` vergleicht nicht. Es versucht, den Wert in die
Eigenschaft zu schreiben. Bei echten Objekten scheitert das meist, bei einfachen Daten ändert
es still jedes Objekt, und der Filter lässt nichts durch.

**Ein Platzhalter mit -eq.** `$_.Name -eq 'Nordwind*'` sucht einen Dienst, der wörtlich
Nordwind mit einem Stern dahinter heißt.

**Eine Eigenschaft ohne $_.** In den Klammern lässt `Status -eq 'Running'` PowerShell nach
einem Befehl namens Status suchen.

Liefert ein Filter nichts, teste die Bedingung allein an einem Objekt, das du kennst.

## Beispiel

```powershell
$One = Get-Service -Name Spooler
$One.Status -eq 'Running'
$One.Name -like 'Spo*'
```

Jede Zeile gibt True oder False aus. Gibt sie etwas anderes oder nichts aus, ist die
Bedingung das Problem, nicht die Pipeline.
