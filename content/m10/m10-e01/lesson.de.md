# Die drei Ansichten

Erreichen Objekte das Ende einer Pipeline, muss PowerShell sie zeichnen. Sagst du nichts,
wählt es eine Standardansicht. Mit drei Cmdlets entscheidest du selbst.

- `Format-Table` zeichnet Spalten. Gut, um viele Objekte anhand weniger Eigenschaften zu
  vergleichen. `-AutoSize` macht die Spalten so schmal, wie der Inhalt erlaubt.
- `Format-List` zeichnet eine Eigenschaft pro Zeile. Gut, um ein oder zwei Objekte
  vollständig anzusehen. `-Property *` zeigt jede Eigenschaft, auch die, die die
  Standardansicht verbirgt.
- `Format-Wide` zeichnet eine einzelne Eigenschaft in mehreren Spalten. Gut für eine schnelle
  Namensliste. `-Column` legt die Anzahl fest.

Alle drei nehmen `-Property`, um auszuwählen, was gezeigt wird.

Ohne Format-Cmdlet nutzt PowerShell für Objekte mit bis zu vier Eigenschaften eine Tabelle
und für mehr eine Liste, sofern der Typ keine eigene Ansicht mitbringt.

## Beispiel

```powershell
Get-Service | Format-Table -Property Name, Status -AutoSize
Get-Service -Name Spooler | Format-List -Property *
Get-Service | Format-Wide -Property Name -Column 4
```

Zeile 2 ist der schnellste Weg, alles zu sehen, was ein einzelnes Objekt enthält.
