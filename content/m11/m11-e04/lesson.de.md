# Wenn Ströme vermischt sind

Drei Verwechslungen machen Skripte für andere Skripte unbrauchbar, und jede zeigt ein klares
Symptom.

**Daten an den Host geschrieben.** `Write-Host $Names` zeigt die Namen und liefert nichts.
Das Symptom: Von Hand gibt das Skript sauber aus, aber eine Variable, die es auffängt, ist
leer.

**Ein Statustext im Ergebnis.** `Write-Output 'Reading services'` setzt diesen Satz ins
Ergebnis, vor die Daten. Das Symptom: Das erste Element des Ergebnisses ist ein Satz, und
was auch immer das Ergebnis verarbeitet, stolpert darüber.

**Die falsche Stromnummer.** `2>` leitet Fehler um. Eine Warnung von `Write-Warning` ist
Strom 3 und geht daran vorbei. Das Symptom: Die Logdatei bleibt leer, und die Warnung
erscheint weiter am Bildschirm.

Um zu sehen, was ein Skript wirklich liefert, fange es auf und zähle:

## Beispiel

```powershell
$Result = .\check.ps1
$Result.Count
$Result | Get-Member
```

Ist die Anzahl höher als erwartet oder meldet `Get-Member` mehr als einen Typ, ist etwas ins
Ergebnis geraten, das keine Daten sind.
