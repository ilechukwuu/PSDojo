# Fehlermeldungen lesen

Roter Text ist keine Katastrophe. PowerShell sagt dir damit genau, was es nicht verstanden
hat. Lies den ersten Satz, er nennt den Schuldigen.

Drei Anfängerfehler verursachen die meisten Meldungen:

- Ein Tippfehler im Cmdlet-Namen. Die Meldung sagt, der Begriff wurde nicht als Name eines
  Cmdlets erkannt.
- Ein Tippfehler im Parameternamen. Die Meldung sagt, es wurde kein Parameter gefunden, der
  dem Namen entspricht.
- Ein fehlender Bindestrich vor einem Parameter. PowerShell behandelt das Wort dann als Wert
  und beschwert sich über diesen Wert.

Groß- und Kleinschreibung spielen keine Rolle: `get-process` funktioniert. Schreibe Namen
trotzdem so, wie das Cmdlet sie zeigt, das liest sich besser.

Der Wortlaut der Meldungen unterscheidet sich leicht zwischen Windows PowerShell 5.1 und
PowerShell 7. Die Bedeutung ist dieselbe.

## Beispiel

```powershell
Get-Procces -Name spoolsv
# The term 'Get-Procces' is not recognized as a name of a cmdlet ...

Get-Process -Name spoolsv
```

Die Meldung zitiert den falsch geschriebenen Namen. Vergleiche ihn Buchstabe für Buchstabe
mit dem, was du gemeint hast.
