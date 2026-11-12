# Aufgabe

Die Zeile in deiner Übungsdatei durchsucht den Logordner von APP-01. Sie hat fünf Parameter
und läuft weit aus dem Bildschirm. Schreibe sie mit Splatting um.

1. Lege eine Hashtable namens `$LogSearch` mit den fünf Parametern an, einen pro Zeile.
2. Rufe `Get-ChildItem` mit `@LogSearch` und sonst nichts auf und speichere das Ergebnis in
   `$Logs`.

`$Logs` muss dieselben Dateien enthalten wie jetzt. Lass die Zeile mit `param` unverändert.
