# Layout

PowerShell ist es egal, wie ein Skript aussieht. Menschen nicht. Ein Skript, das überall
gleich aufgebaut ist, lässt sich mit einem Blick prüfen, und Fehler fallen auf.

Die Regeln, auf die sich die meisten Teams einigen:

- Eine Anweisung pro Zeile. Ein Semikolon kann mehrere Anweisungen in eine Zeile packen,
  aber dann übersieht man die zweite leicht.
- Je ein Leerzeichen links und rechts von `=` und anderen Operatoren.
- Keine Tabulatoren. Einrücken mit vier Leerzeichen, und nur dort, wo ein Block
  verschachtelt ist. Zeilen auf oberster Ebene beginnen in der ersten Spalte.

VS Code formatiert eine Datei für dich: Umschalt+Alt+F, oder Rechtsklick und Dokument
formatieren. Die ISE hat keinen Formatierer, dort machst du es von Hand. Blende beim Lernen
Leerraum ein: Ansicht, Leerraum rendern in VS Code, und die Option Leerraum anzeigen in den
Einstellungen der ISE.

## Beispiel

```powershell
$Server='FS-02';$Share='Transfer'

$Server = 'FS-02'
$Share = 'Transfer'
```

Zeile 1 und die Zeilen 3 bis 4 tun dasselbe. In der ersten Fassung versteckt sich die zweite
Zuweisung hinter dem Semikolon.
