# Aufgabe

Das Skript in deiner Übungsdatei prüft vier Prozesse auf TS-03 nacheinander und klebt die
Ergebnisse zusammen. Schreibe es so um, dass `Get-Process` genau einmal aufgerufen wird.

1. Behalte die Zeile, die `$Names` definiert.
2. Weise `$Found` mit einem einzigen Aufruf von `Get-Process` zu, der die ganze Liste erhält.
3. Entferne die Hilfsvariablen `$p1` bis `$p4`.

`$Found` muss dieselben vier Prozesse enthalten wie jetzt.
