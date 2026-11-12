# Aufgabe

Das Skript in deiner Übungsdatei schreibt die Ankündigung für eine Patchnacht. Es
funktioniert für genau drei Server, weil es jede Position nennt. Schreibe es so um, dass es
für jede Anzahl funktioniert.

1. `$Line` verbindet alle Server mit Komma und Leerzeichen. Nutze `-join`.
2. `$LastTwo` enthält die letzten zwei Server. Nutze einen Ausschnitt mit negativen
   Positionen.
3. `$Summary` bleibt ein Text der Form `3 servers: FS-01, FS-02, FS-03`, gebaut aus der
   Anzahl und `$Line`.

Kein `+` darf übrig bleiben. Lass die Zeile mit `param` unverändert, das Dojo übergibt
darüber verschiedene Listen.
