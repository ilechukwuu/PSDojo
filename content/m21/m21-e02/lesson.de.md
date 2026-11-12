# JSON

JSON ist das Format von Konfigurationsdateien und Webdiensten. Anders als CSV kann es
verschachteln: Ein Wert kann eine Liste oder ein weiteres Objekt mit eigenen Werten sein, und
Zahlen und Wahrheitswerte behalten ihren Typ.

**Lesen.** Lies die ganze Datei als einen Text und leite ihn in `ConvertFrom-Json`:

`Get-Content -Path config.json -Raw | ConvertFrom-Json`

`-Raw` ist wichtig. Ohne es liefert `Get-Content` die Zeilen einzeln. Das Ergebnis ist ein
Objekt. Verschachtelte Teile erreichst du mit Punkten, Listen mit einem Index, und eine
Eigenschaft an einer Liste liefert sie von jedem Element.

**Schreiben.** `ConvertTo-Json` macht aus Objekten JSON-Text. Die Standardtiefe ist 2. Teile,
die tiefer liegen, werden nicht richtig umgewandelt: Sie werden zu einem Text mit dem
Typnamen. Gib `-Depth` mit einem ausreichend großen Wert an, zum Beispiel 5.

Zum Speichern leitest du den Text in `Set-Content` mit `-Encoding UTF8`.

## Beispiel

```powershell
$Config = Get-Content -Path D:\Config\monitor.json -Raw | ConvertFrom-Json
$Config.thresholds.warnPercent
$Config.servers[0].name
$Config.servers.name

$Config | ConvertTo-Json -Depth 5 | Set-Content -Path D:\Config\copy.json -Encoding UTF8
```
