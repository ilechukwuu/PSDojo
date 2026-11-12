# Aufgabe

Das Wartungsskript in deiner Übungsdatei bewertet einen Server vor dem Patchen. Es hat drei
Logikfehler. Behebe sie. Lass die Zeile mit `param` unverändert.

Wenn das Skript funktioniert:

- `$ShouldStart` ist nur dann `$true`, wenn `$Status` `Stopped` ist, und `$Status` behält
  seinen Wert.
- `$Priority` ist `High` unter 10 Prozent frei, `Medium` unter 20 und sonst `Low`.
- `$Role` ist genau ein Text: `File server` für Namen, die mit `FS-` beginnen, sonst `Other`.
