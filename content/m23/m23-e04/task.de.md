# Aufgabe

Ein Kollege meldet: "Ich habe die Ausführungsrichtlinie auf PRN-01 auf RemoteSigned gesetzt,
und mein Skript läuft immer noch nicht." Du schreibst die wenigen Zeilen, die zeigen, welche
Richtlinie wirklich gilt und woher sie kommt.

1. Speichere das Ergebnis von `Get-ExecutionPolicy -List` in `$Policies`.
2. Finde den ersten Eintrag, dessen `ExecutionPolicy` nicht `Undefined` ist, und speichere
   ihn in `$Winner`. Die Liste ist bereits in der Rangfolge.
3. Speichere die Richtlinie dieses Eintrags als Text in `$Effective`.
4. Speichere den Bereich dieses Eintrags als Text in `$SetBy`.

Das Dojo ersetzt das Cmdlet durch erfundene Daten, auf deinem Rechner wird also nichts
gelesen oder geändert.
