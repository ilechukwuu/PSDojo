# Parameter

Parameter steuern, was ein Cmdlet tut. Ein Parameter beginnt mit einem Bindestrich, sein
Wert folgt nach einem Leerzeichen.

- **Benannt**: `-Name spoolsv`. Du schreibst den Namen, dann den Wert. In Skripten immer so.
- **Positional**: `Get-Process spoolsv`. Manche Parameter nehmen einen Wert allein wegen
  seiner Position an. Schnell getippt, schwerer zu lesen.
- **Schalter**: `-Recurse`. Kein Wert, er ist entweder da oder nicht.

Manche Parameter nehmen mehrere Werte an, getrennt durch Kommas: `-Name spoolsv, lsass`.

Text mit Leerzeichen oder Sonderzeichen gehört in Anführungszeichen:
`-Format 'dd.MM.yyyy HH:mm'`.

Parameternamen musst du nicht tippen. Tippe einen Bindestrich und drücke Tab, um durch die
Parameter des Cmdlets zu blättern. Das geht in der Konsole, in der ISE und in VS Code.

## Beispiel

```powershell
Get-Date -Year 2026 -Month 12 -Day 24
Get-Date -Format 'dd.MM.yyyy'
Get-Command -Name Get-Date -Syntax
```

Die erste Zeile baut ein Datum aus drei benannten Parametern. Alles, was du weglässt, kommt
aus der aktuellen Uhrzeit. Die zweite Zeile liefert das Datum als Text. In der dritten Zeile
ist `-Syntax` ein Schalter: `Get-Command` zeigt damit, wie `Get-Date` aufgerufen werden kann.
