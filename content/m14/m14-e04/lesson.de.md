# Here-Strings und Textmethoden

Ein Mailtext, ein Konfigurationsschnipsel oder eine SQL-Anweisung läuft über mehrere Zeilen
und enthält oft Anführungszeichen. Das aus Stücken mit `+` zu bauen ist mühsam. Ein
Here-String hält es so, wie es ist.

Er beginnt mit `@"` am Ende einer Zeile und endet mit `"@` ganz am Anfang einer Zeile. Alles
dazwischen ist der Text, mit Zeilenumbrüchen und Anführungszeichen. Variablen und `$( )`
werden ersetzt wie in doppelten Anführungszeichen. Mit `@'` und `'@` wird nichts ersetzt.

Die schließende Marke muss in der ersten Spalte stehen. Sie einzurücken ist der klassische
Fehler.

Um Text zu bereinigen, der von außen kommt, erledigen ein paar Methoden die meiste Arbeit:

- `Trim()` entfernt Leerzeichen und Zeilenumbrüche an beiden Enden.
- `Split('.')` zerschneidet an einem Zeichen, `[0]` nimmt den ersten Teil.
- `ToUpper()` und `ToLower()` ändern die Schreibweise.
- `StartsWith()` und `EndsWith()` prüfen Anfang und Ende. Sie unterscheiden Groß- und
  Kleinschreibung.

## Beispiel

```powershell
$Server = 'FS-02'
$Body = @"
Hello team,
"$Server" needs attention.
"@

'  fs-02.nordwind.example '.Trim().Split('.')[0].ToUpper()
```

`$Body` sind zwei Zeilen Text. Die letzte Zeile liefert FS-02.
