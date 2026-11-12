# Aufgabe

Der Kapazitätsbericht in deiner Übungsdatei liest `disks.csv`, die durch Semikolons getrennt
ist, und schreibt eine Zusammenfassung als JSON. Er hat drei Fehler. Behebe sie. Lass die
Zeile mit `param` unverändert.

Wenn das Skript funktioniert:

- `$Rows` enthält Zeilen mit den Eigenschaften `Server`, `Drive` und `FreeGB`.
- `$TotalFree` ist die Summe aller `FreeGB`-Werte als Zahl.
- Die Datei `summary.json` in `$Folder` enthält weiterhin die Laufwerksbuchstaben jeder
  Zeile.
