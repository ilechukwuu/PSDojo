# Aufgabe

Die Personalabteilung schickt eine Liste, in der jeder Eintrag anders aussieht. Bevor die
Konten angelegt werden, bereinigst du die Werte. Die ersten Zeilen deiner Übungsdatei
enthalten drei Rohwerte. Lass sie unverändert.

1. Ersetze jede Folge von Leerraum in `$RawName` durch ein einzelnes Leerzeichen und
   speichere das Ergebnis in `$Name`.
2. `$Name` hat jetzt die Form `Nachname, Vorname`. Mach daraus mit einem `-replace` und zwei
   Gruppen `Vorname Nachname` und speichere das Ergebnis in `$DisplayName`.
3. Entferne aus `$Mail` alles ab dem `@` und speichere den Rest in `$Login`.
4. Prüfe `$Ticket` mit einem Muster, das die benannten Gruppen `Prefix` und `Number` hat:
   Buchstaben, ein Bindestrich, Ziffern. Speichere die zwei Teile in `$TicketPrefix` und, als
   ganze Zahl, in `$TicketNumber`.
