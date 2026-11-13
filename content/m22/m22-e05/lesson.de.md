# Sicher löschen

`Remove-Item` löscht endgültig. Es gibt keinen Papierkorb und kein Rückgängig. Ein
Aufräumskript besteht deshalb aus zwei getrennten Schritten:

1. **Sammle** die zu löschenden Dateien in einer Variablen. Jetzt kannst du sie zählen,
   ansehen und in ein Log schreiben.
2. **Lösche** genau diese Liste.

Jedes Cmdlet, das etwas ändert, hat den Schalter `-WhatIf`. Damit gibt das Cmdlet nur aus,
was es tun würde. Nichts wird geändert.

Ein Skript kann denselben Schalter selbst anbieten. Deklariere `[switch]$WhatIf` in `param`
und reiche den Wert mit einem Doppelpunkt weiter: `-WhatIf:$WhatIf`. Mit `-WhatIf` aufgerufen
macht das Skript einen Probelauf, ohne löscht es. Der Doppelpunkt ist nötig, weil ein
Schalter normalerweise keinen Wert nimmt.

Wenn du Dateiobjekte übergibst, nutze `-LiteralPath $File.FullName`. `-Path` deutet Zeichen
wie `[` und `]` in einem Namen als Muster.

## Beispiel

```powershell
param($Root = '.', [switch]$WhatIf)

$Limit = (Get-Date).AddDays(-14)
$Dumps = Get-ChildItem -Path $Root -Filter '*.dmp' -File -Recurse |
    Where-Object { $_.LastWriteTime -lt $Limit }

foreach ($Dump in $Dumps) {
    Remove-Item -LiteralPath $Dump.FullName -WhatIf:$WhatIf
}
```
