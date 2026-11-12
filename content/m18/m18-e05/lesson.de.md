# Wann switch besser ist

Eine Kette von `elseif`, die dieselbe Variable mit einem festen Wert nach dem anderen
vergleicht, ist eine verkleidete Tabelle: Dieser Wert ergibt jenes Ergebnis. Als Kette
geschrieben wiederholen sich Variable und Operator in jeder Zeile, und der eigentliche
Inhalt, die Paare, ist schwer zu sehen.

`switch` zeigt die Tabelle als Tabelle.

- Die Variable wird einmal genannt.
- Jede Zeile ist ein Fall und sein Ergebnis.
- Ein neuer Fall ist eine neue Zeile.
- `default` macht sichtbar, was mit allem anderen geschieht. In einer `if`-Kette übersieht
  man ein fehlendes `else` leicht.

Bleibe bei `if`, wenn die Bedingungen verschiedener Art sind: Eine vergleicht eine Zahl, die
nächste prüft einen Text, eine dritte ruft einen Befehl auf. Ein `switch` ist für einen Wert
gegen viele Fälle.

## Beispiel

```powershell
if ($Code -eq 0) { $Text = 'OK' }
elseif ($Code -eq 1) { $Text = 'Warning' }
elseif ($Code -eq 2) { $Text = 'Error' }
else { $Text = 'Unknown' }

$Text = switch ($Code) {
    0       { 'OK' }
    1       { 'Warning' }
    2       { 'Error' }
    default { 'Unknown' }
}
```
