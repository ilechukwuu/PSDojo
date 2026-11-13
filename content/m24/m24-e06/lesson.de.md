# Modul 24 im Rückblick

Dieses Quiz schließt das Modul ab. Es behandelt, was du in den Übungen davor benutzt hast:

- Ein Skriptblock ist Code als Wert. Ihn zu definieren führt nichts aus.
- `&` ruft einen Block auf, `param` gibt ihm Eingaben.
- Cmdlets setzen `$_` für Blöcke, die sie ausführen. Ein selbst aufgerufener Block hat kein
  `$_`.
- Übergib eine Blockvariable direkt, ohne Klammern darum.
- Äussere Variablen werden beim Aufruf gelesen. `GetNewClosure()` friert sie ein.
- Baue nie Befehle als Text für `Invoke-Expression`.

Du bestehst mit 80 Prozent. Fällst du durch, kannst du es beliebig oft erneut versuchen. Die
Rückmeldung nennt die falsch beantworteten Fragen, nicht die richtige Antwort.

## Beispiel

```powershell
$Answer1 = 'b'
```

Jede Antwort ist der Buchstabe einer Option, in Anführungszeichen.
