# Hashtables

Ein Array findet seine Elemente über die Position. Eine Hashtable findet sie über einen
Namen. Sie speichert Paare: einen Schlüssel (Key) und den Wert, der dazugehört.

Du schreibst sie als `@{ }` mit den Paaren darin, getrennt durch Semikolons oder
Zeilenumbrüche.

- **Lesen** eines Werts mit dem Schlüssel in eckigen Klammern, `$Limits['D:']`, oder mit
  einem Punkt, `$Server.Site`. Ein Schlüssel, den es nicht gibt, liefert `$null`.
- **Hinzufügen oder ändern** durch Zuweisen: `$Limits['E:'] = 20`. Gibt es den Schlüssel,
  wird sein Wert ersetzt, sonst kommt das Paar dazu.
- **Prüfen** mit `ContainsKey('E:')`.
- `Count` ist die Zahl der Paare, `Keys` und `Values` sind die zwei Seiten.

Schlüssel mit Leerzeichen oder Sonderzeichen wie einem Doppelpunkt brauchen
Anführungszeichen.

Eine einfache Hashtable behält die Reihenfolge nicht, in der du die Paare hinzugefügt hast.
`[ordered]@{ }` tut es.

## Beispiel

```powershell
$Limits = @{ 'C:' = 10; 'D:' = 50 }
$Limits['D:']
$Limits['E:'] = 20
$Limits.ContainsKey('F:')
$Limits.Count
```

Die Ergebnisse sind 50, dann nichts für die Zuweisung, False und 3.
