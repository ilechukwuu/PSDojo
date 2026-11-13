# Modul 26 im Rückblick

Dieses Quiz schließt das Modul ab. Es behandelt, was du in den Übungen davor benutzt hast:

- `[CmdletBinding()]` direkt über `param` gibt einer Funktion die allgemeinen Parameter.
- `[Parameter(Mandatory)]` erzwingt einen Wert.
- `Write-Verbose` für Statusmeldungen, nie blanker Text im Rumpf.
- Validierungsattribute lehnen falsche Eingaben ab, bevor der Rumpf läuft.
- Die Bindung wandelt erst um und validiert danach.
- Unbeaufsichtigte Skripte laufen mit `-NonInteractive`.

Du bestehst mit 80 Prozent. Fällst du durch, kannst du es beliebig oft erneut versuchen. Die
Rückmeldung nennt die falsch beantworteten Fragen, nicht die richtige Antwort.

## Beispiel

```powershell
$Answer1 = 'b'
```

Jede Antwort ist der Buchstabe einer Option, in Anführungszeichen.
