# Rangfolge

Hat ein Ausdruck mehrere Operatoren, geht PowerShell nicht einfach von links nach rechts
vor. Es folgt einer festen Reihenfolge.

1. Runde Klammern zuerst.
2. `-not` und `!`.
3. `*`, `/` und `%`.
4. `+` und `-`.
5. Vergleiche wie `-eq`, `-gt`, `-like`.
6. `-and` und `-or`. Diese zwei haben denselben Rang und werden von links nach rechts
   gelesen.

Gerechnet wird also, bevor irgendetwas verglichen wird, und alle Vergleiche sind fertig,
bevor sie verknüpft werden.

Rang 6 ist die Falle. `A -or B -and C` wird als `(A -or B) -and C` gelesen, was selten
gemeint war.

Niemand sollte diese Tabelle auswendig kennen müssen, um dein Skript zu lesen. Setze
Klammern überall, wo zwei verschiedene Arten von Operatoren aufeinandertreffen. Sie kosten
nichts und beseitigen jeden Zweifel.

## Beispiel

```powershell
2 + 3 * 4
(2 + 3) * 4
10 - 4 -gt 5
$true -or $false -and $false
```

Die Ergebnisse sind 14, 20, True und False. In Zeile 4 wird zuerst das `-or` ausgewertet,
dann das `-and` mit `$false`.
