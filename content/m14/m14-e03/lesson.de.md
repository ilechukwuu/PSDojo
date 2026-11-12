# Der Formatoperator

Braucht ein Text mehr als einen eingesetzten Wert, eine Zahl mit führenden Nullen, Spalten,
die untereinander stehen, ein Datum in festem Aufbau, ist der Formatoperator `-f` das
Werkzeug.

Links steht eine Vorlage mit nummerierten Platzhaltern in geschweiften Klammern. Rechts
stehen die Werte, getrennt durch Kommas. `{0}` nimmt den ersten Wert, `{1}` den zweiten.

Ein Platzhalter kann sagen, wie der Wert dargestellt wird:

- `{0:D3}` schreibt eine ganze Zahl mit mindestens drei Stellen: Aus 7 wird 007.
- `{0:yyyy-MM-dd}` schreibt ein Datum in genau diesem Aufbau.
- `{0,8}` reserviert acht Zeichen und richtet den Wert rechts aus. `{0,-8}` richtet links
  aus.

Formate für Nachkommastellen und Prozent, etwa `{0:N1}`, benutzen das Dezimaltrennzeichen
der Systemsprache. Auf einem deutschen System ist das ein Komma. Denk daran bei Dateien, die
Programme lesen.

## Beispiel

```powershell
'SRV-{0:D3}' -f 7
'{0:yyyy-MM-dd}' -f (Get-Date)
'{0,-8}{1,6}' -f 'FS-02', 75
```

Zeile 1 ergibt SRV-007. Zeile 3 ergibt FS-02, aufgefüllt auf acht Zeichen, gefolgt von 75,
rechts ausgerichtet in sechs.
