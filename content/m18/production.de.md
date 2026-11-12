# Was in der Produktion schiefgeht

Ein Wartungsskript soll einen Dienst nur stoppen, wenn er läuft:

```powershell
if ($Service.Status = 'Running') { Stop-Service -Name $Service.Name }
```

Ein einzelnes Gleichheitszeichen weist zu. Bei den Testdaten ließ sich die Eigenschaft
schreiben, die Zuweisung lieferte den Text Running, und ein nicht leerer Text zählt als wahr.
Der Block lief für jeden Dienst der Liste, auch für absichtlich gestoppte, die nun einen
verwirrenden Fehler bekamen, und die eigenen Daten des Skripts sagten danach bei allen
Running.

Nutze in einer Bedingung immer `-eq`. Und ist eine Bedingung für alles wahr oder für alles
falsch, verdächtige zuerst den Operator.
