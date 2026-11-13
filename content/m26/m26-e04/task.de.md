# Aufgabe

Die Funktion in deiner Übungsdatei soll einen Wiederherstellungsauftrag beschreiben. Sie lädt
nicht, und sobald sie lädt, lehnt sie gültige Eingaben ab und liefert zu viel. Sie hat drei
Fehler. Behebe sie.

Wenn sie funktioniert:

- Die Datei lädt ohne Syntaxfehler.
- `Get-RestoreJob -ComputerName FS-01 -Source Tape` wird akzeptiert, ebenso `Disk` und
  `Cloud`.
- Die Funktion liefert genau ein Objekt. Der Text `Preparing restore for <Name>` erscheint
  nur mit `-Verbose`.
