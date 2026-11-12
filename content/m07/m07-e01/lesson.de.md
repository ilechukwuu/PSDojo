# Wie die Pipe einen Parameter findet

Kommt ein Objekt durch die Pipe an, muss der empfangende Befehl entscheiden, welcher seiner
Parameter es bekommt. Er rät nie. Er folgt zwei Regeln, und die Hilfe zeigt bei jedem
Parameter, welche gelten: `Accept pipeline input?`

**ByValue.** Der Parameter nimmt das ganze Objekt, wenn dessen Typ passt. Ein Dienstobjekt
passt zu einem Parameter vom Typ ServiceController, ein Text zu einem Parameter vom Typ
string.

**ByPropertyName.** Der Parameter nimmt den Wert einer Eigenschaft, die genauso heißt wie
der Parameter. Ein Objekt mit einer Eigenschaft `Name` füttert den Parameter `-Name`.

PowerShell versucht zuerst ByValue. Nur wenn kein Parameter das Objekt als Ganzes annimmt,
schaut es auf Eigenschaftsnamen.

Ein Parameter mit `false` nimmt nichts aus der Pipe. Und ein Parameter, den du schon von
Hand gesetzt hast, steht für Pipeline-Eingabe nicht mehr zur Verfügung.

## Beispiel

```powershell
Get-Help -Name Stop-Service -Parameter InputObject
Get-Help -Name Stop-Service -Parameter Name

Get-Service -Name Spooler | Stop-Service -WhatIf
```

Das Dienstobjekt bindet über den Wert an `-InputObject`. `-WhatIf` zeigt, was passieren
würde, ohne es zu tun.
