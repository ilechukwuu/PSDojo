# Aufgabe

Die Zustandsprüfung in deiner Übungsdatei entscheidet mit einer `if`-Kette, ob ein Messwert
gesund ist. Jede neue Art von Prüfung macht die Kette länger. Schreibe sie als Tabelle um.

1. Speichere eine Hashtable in `$Checks` mit den Schlüsseln `Disk`, `Memory` und `Latency`.
   Jeder Wert ist ein Skriptblock mit einem Parameter `$Value`, der nach derselben Regel wie
   bisher `$true` oder `$false` liefert.
2. Schlage den Block für `$CheckName` nach, rufe ihn mit `$Value` auf und speichere das
   Ergebnis in `$Healthy`.
3. Kein `if` darf übrig bleiben.

Lass die Zeile mit `param` unverändert.
