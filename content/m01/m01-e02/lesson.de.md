# Verb-Noun

Jeder Cmdlet-Name ist gleich aufgebaut: ein Verb, ein Bindestrich, ein Substantiv (Noun). Das
Verb sagt, was passiert, das Noun sagt, womit. Kennst du das Muster, kannst du Befehle lesen,
die du noch nie gesehen hast.

Die Verben stammen aus einer festen Liste, die `Get-Verb` anzeigt. Die wichtigsten im Alltag:

- `Get` liest. Es ändert nie etwas, du kannst es gefahrlos ausprobieren.
- `Set` ändert etwas Vorhandenes.
- `New` legt an, `Remove` löscht.
- `Start`, `Stop` und `Restart` steuern alles, was läuft.

Das Noun steht immer in der Einzahl: `Get-Service`, nicht `Get-Services`, auch wenn viele
Dienste zurückkommen.

Weil das Muster verlässlich ist, darfst du raten. Gibt es `Get-Service` und `Stop-Service`,
gibt es wahrscheinlich auch `Restart-Service`.

Die Service-Cmdlets gibt es nur unter Windows.

## Beispiel

```powershell
Get-Service -Name Spooler
Restart-Service -Name Spooler
```

Die erste Zeile liest nur den Zustand der Druckwarteschlange. Die zweite Zeile verändert den
Server: Jeder Druckauftrag in der Warteschlange wird unterbrochen.
