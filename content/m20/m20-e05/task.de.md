# Aufgabe

Das Skript in deiner Übungsdatei prüft Eingaben, bevor ein Server in die Überwachung
aufgenommen wird. Drei Muster sind falsch. Behebe sie. Lass die Zeile mit `param`
unverändert.

Wenn das Skript funktioniert:

- `$IsServerName` ist nur dann wahr, wenn `$Candidate` genau `FS-` gefolgt von zwei Ziffern
  ist.
- `$IsInternal` ist nur dann wahr, wenn `$Fqdn` mit `.nordwind.example` endet, mit echten
  Punkten.
- `$Owner` macht aus `$Person` in der Form `Nachname, Vorname` die Form `Vorname Nachname`.
