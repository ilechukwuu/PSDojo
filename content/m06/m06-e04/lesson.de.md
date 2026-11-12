# Klammern oder nicht

Eigenschaften und Methoden sehen ähnlich aus, und wer sie verwechselt, macht drei typische
Fehler.

**Eine Methode ohne Klammern.** `$Server.ToUpper` scheitert nicht. Es liefert eine
Beschreibung der Methode, ein paar Zeilen über Überladungen. In einer Variablen gespeichert
und später benutzt, ergibt das sehr merkwürdige Ausgaben.

**Eine Eigenschaft mit Klammern.** `$Server.Length()` scheitert mit der Meldung, dass der Typ
keine Methode namens Length enthält.

**Ein Argument ohne Klammern.** `$Start.AddDays 7` ist ein Syntaxfehler. Argumente einer
Methode stehen immer in den Klammern, anders als die Parameter eines Cmdlets.

Bist du unsicher, was was ist, frage `Get-Member`. Die Spalte MemberType sagt Property oder
Method, und bei einer Methode zeigt die Spalte Definition, welche Argumente sie erwartet.

## Beispiel

```powershell
$Server = 'fs-02'
$Server.ToUpper
$Server.ToUpper()
$Server.Length
```

Zeile 2 gibt eine Tabelle über die Methode aus. Zeile 3 ruft sie auf und liefert FS-02. Zeile
4 liest eine Eigenschaft und braucht keine Klammern.
