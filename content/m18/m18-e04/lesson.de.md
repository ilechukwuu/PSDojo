# Logikfehler

Logikfehler lösen keine Fehler aus. Das Skript nimmt den falschen Zweig und tut mit voller
Überzeugung das Falsche.

**= in einer Bedingung.** `if ($Status = 'Stopped')` weist den Text zu und prüft ihn dann.
Ein nicht leerer Text ist wahr, der Block läuft also immer, und die Variable wird nebenbei
überschrieben.

**Bedingungen in falscher Reihenfolge.** Steht `if ($Free -lt 20)` oben und
`elseif ($Free -lt 10)` darunter, wird das zweite nie erreicht: Alles unter 10 liegt auch
unter 20.

**Ein switch, der zweimal trifft.** `switch` prüft jeden Fall. Mit `-Wildcard` passt ein Name
wie FS-02 auf `'FS-*'` und auch auf `'*'`. Beide Blöcke laufen, und das Ergebnis ist eine
Liste aus zwei Werten statt einem. Beende einen Block mit `break`, oder nutze `default` für
den Rest.

Teste jeden Zweig mindestens einmal mit einem Wert, der hineingehören sollte.

## Beispiel

```powershell
$Role = switch -Wildcard ($Server) {
    'FS-*' { 'File server'; break }
    '*'    { 'Other' }
}
```

Ohne das `break` bekäme ein Dateiserver beide Texte.
