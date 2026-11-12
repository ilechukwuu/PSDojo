# Binden über den Wert

Eine Pipeline muss nicht mit einem Befehl beginnen. Links kann jeder Wert stehen: ein Text,
eine Variable, eine durch Kommas getrennte Liste. Eine Liste wird zerlegt, und jedes Element
wandert einzeln durch die Pipe.

Hat der empfangende Befehl einen Parameter, der diesen Typ über den Wert annimmt, bindet
jedes Element dort, und der Befehl arbeitet einmal pro Element.

So werden Listen zu Arbeitsaufträgen:

- `'Get-Date', 'Get-Item' | Get-Command` schlägt zwei Befehle nach. Die Texte binden an
  `-Name`.
- Eine Liste von Pfaden, in `Get-Item` geleitet, liefert ein Item pro Pfad. Die Texte binden
  an `-Path`.

Ob ein Befehl Text über den Wert annimmt und an welchem Parameter, darfst du nicht
voraussetzen. `Get-Help -Parameter *` zeigt es. `Get-Process` zum Beispiel nimmt einfachen
Text gar nicht über den Wert an.

## Beispiel

```powershell
'Get-Date', 'Get-Item' | Get-Command

$Paths = 'D:\Reports\a.csv', 'D:\Reports\b.csv'
$Paths | Get-Item
```

Zeile 1 liefert zwei Befehlsobjekte. Zeile 4 liefert zwei Dateiobjekte, eines für jeden Pfad
in der Variablen.
