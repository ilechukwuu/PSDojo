# Aufgabe

Das Skript in deiner Übungsdatei sammelt die Namen und den gesamten Arbeitsspeicher der
Prozesse einer Fachanwendung auf TS-03. Es holt jeden Prozess über seine Position. Das
funktioniert heute, mit genau drei Prozessen.

Schreibe es so um, dass es für jede Anzahl von Prozessen funktioniert:

1. `$Names` wird in einem Schritt aus `$All` gelesen.
2. `$TotalMemory` addiert `WorkingSet64` aller Prozesse mit `Measure-Object -Sum`.
3. Kein `[0]`, `[1]` oder `[2]` bleibt übrig, und außer `$All`, `$Names` und `$TotalMemory`
   wird keine Variable zugewiesen.
