# Cmdlets erledigen die Arbeit

Befehle heißen in PowerShell Cmdlets, gesprochen "Command-lets". Du tippst den Namen, drückst
Enter, PowerShell führt ihn aus und zeigt das Ergebnis.

Ein Cmdlet liefert keinen Text. Es liefert Objekte: strukturierte Daten mit Eigenschaften.
`Get-Process` liefert ein Objekt pro laufendem Prozess, `Get-Date` liefert ein Datumsobjekt.
Darauf baut jedes spätere Modul auf.

Um ein Ergebnis zu behalten, speicherst du es in einer Variablen. Ein Variablenname beginnt
mit `$`.

Vorsicht mit Anführungszeichen. Sie machen aus einem Befehl reinen Text: `'Get-Date'` sind
nur acht Zeichen, ausgeführt wird nichts.

Das Dojo prüft deine Arbeit, indem es die Variablen in deiner Übungsdatei liest. Deshalb
sollst du Ergebnisse fast immer unter einem vorgegebenen Namen speichern.

## Beispiel

```powershell
$Today = Get-Date
$Today
```

Die erste Zeile führt `Get-Date` aus und speichert das Datumsobjekt in `$Today`. Die zweite
Zeile zeigt, was in der Variablen steckt.
