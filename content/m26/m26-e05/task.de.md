# Aufgabe

Die Funktion in deiner Übungsdatei beschreibt, was mit Konten geschehen soll, die sich lange
nicht angemeldet haben. Sie prüft ihre Eingaben mit drei handgeschriebenen `if`-Anweisungen.
Schreibe sie um.

1. Ergänze `[CmdletBinding()]`.
2. `$Name` wird Pflicht.
3. `$Days` akzeptiert nur 30 bis 365, deklariert mit einem Attribut.
4. `$Mode` akzeptiert nur `Report` und `Disable`, deklariert mit einem Attribut.
5. Kein `if` und kein `throw` darf übrig bleiben. Die Funktion liefert weiterhin dasselbe
   Objekt.
