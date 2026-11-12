# Der Debugger

Beim Lesen erfährst du, was ein Skript tun soll. Der Debugger zeigt, was es wirklich tut. Er
hält das Skript an einer Zeile deiner Wahl an und lässt dich umsehen, solange noch alles im
Speicher ist. Die Tasten sind in ISE und VS Code gleich. Speichere die Datei zuerst, der
Debugger arbeitet nur mit gespeicherten Dateien.

- **F9** setzt oder entfernt einen Haltepunkt in der aktuellen Zeile. Eine rote Marke
  erscheint.
- **F5** startet das Skript. Es hält am ersten Haltepunkt und hebt die Zeile hervor, die als
  nächste läuft.
- **F10** führt diese eine Zeile aus und hält wieder. **F11** tut dasselbe, springt aber
  auch in Funktionen hinein.
- **F5** läuft weiter bis zum nächsten Haltepunkt, **Umschalt+F5** beendet das Debuggen.

Solange das Skript angehalten ist, beginnt die Eingabezeile der Konsole mit `[DBG]`. Tippe
dort einen Variablennamen, um seinen Wert zu sehen. Du kannst auch im Skriptbereich mit der
Maus über eine Variable fahren.

## Beispiel

```powershell
$Total = 0
$Total = $Total + 120
$Total = $Total + 35
```

Setze einen Haltepunkt in Zeile 3 und drücke F5. Das Skript hält, bevor Zeile 3 läuft. Die
Eingabe `$Total` in der Konsole zeigt 120.
