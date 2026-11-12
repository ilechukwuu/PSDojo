# Aufgabe

Die Zertifikatsprüfung für WEB-01 warnt nie. Sie hat drei Datumsfehler. Behebe sie, ohne die
ersten zwei Zeilen zu ändern.

Wenn das Skript funktioniert:

- `$Expires` ist das Datum 3. April 2026.
- `$WarnFrom` liegt 30 Tage vor `$Expires`.
- `$ShouldWarn` ist `$true`, weil heute am oder nach dem `$WarnFrom` liegt.
