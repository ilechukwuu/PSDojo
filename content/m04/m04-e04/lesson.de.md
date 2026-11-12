# Pfade, Items und ihre Typen

Ein Provider-Pfad führt zu einem Item und endet dort. Was du über das Item wissen willst,
kommt danach, als Eigenschaft: `(Get-Item -Path Alias:gci).Definition`. Die Eigenschaft in
den Pfad zu schreiben funktioniert nicht, denn der Provider sucht dann ein Item mit diesem
Namen.

Zwei Parameter entscheiden, welche Art von Item du meinst.

`Test-Path -PathType` prüft mehr als die Existenz:

- `Container` ist etwas, das andere Items enthalten kann, im Dateisystem ein Ordner.
- `Leaf` ist etwas, das das nicht kann, im Dateisystem eine Datei.

`New-Item -ItemType` sagt, was angelegt wird. Im Dateisystem sind die Werte `File` und
`Directory`. Einen Typ namens Folder gibt es nicht.

Pfade mit Leerzeichen brauchen Anführungszeichen. In doppelten Anführungszeichen wird eine
Variable durch ihren Wert ersetzt, aus `"$Root\reports"` wird also der volle Pfad.

`\` und `/` funktionieren in PowerShell auf jeder Plattform als Trenner.

## Beispiel

```powershell
(Get-Item -Path Alias:gci).Definition
Test-Path -Path "$Root\reports" -PathType Container
New-Item -Path "$Root\archive" -ItemType Directory
```

Zeile 2 ist nur wahr, wenn reports existiert und ein Ordner ist.
