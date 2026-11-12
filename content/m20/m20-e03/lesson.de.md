# -replace und Gruppen

`-replace` nimmt ein Muster und einen Ersatztext. Jeder Teil der Eingabe, der auf das Muster
passt, wird gegen den Ersatz getauscht. Ohne Ersatz werden die Treffer entfernt.

Der Ersatz kann auf das verweisen, was die runden Klammern gefangen haben: `$1` ist die erste
Gruppe, `$2` die zweite. So lässt sich ein Text umstellen, statt nur Teile zu löschen oder zu
überschreiben.

Schreibe den Ersatz in **einfachen Anführungszeichen**. In doppelten würde PowerShell `$1`
selbst ersetzen, durch den Wert einer Variablen namens 1, die es nicht gibt, bevor die
Regex-Maschine es je sieht.

Zwei weitere Bausteine:

- `\s+` ist ein oder mehrere Leerraumzeichen. Durch ein Leerzeichen ersetzt räumt es
  unsaubere Eingaben auf.
- `(?<Server>FS-\d+)` gibt einer Gruppe einen Namen. Nach `-match` liest du sie als
  `$Matches['Server']` oder `$Matches.Server`, was mehr sagt als `$Matches[1]`.

## Beispiel

```powershell
'Keller,   Anna' -replace '\s+', ' '
'Keller, Anna' -replace '^(\w+), (\w+)$', '$2 $1'

if ('Disk on FS-02' -match '(?<Server>FS-\d+)') { $Matches.Server }
```

Die Ergebnisse sind `Keller, Anna`, `Anna Keller` und FS-02.
