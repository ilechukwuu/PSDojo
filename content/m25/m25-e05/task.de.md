# Aufgabe

Die Morgenmail in deiner Übungsdatei baut eine Zeile pro Server, dreimal mit demselben Code.
Letzte Woche wurde die Grenze für `LOW` nur in zwei der drei Zeilen geändert. Schreibe es um.

1. Definiere eine Funktion `Format-ServerLine` mit den Parametern `$Name` (Text) und `$FreeGB`
   (ganze Zahl). Sie liefert die Zeile im selben Format wie bisher, mit `LOW`, wenn weniger
   als 50 GB frei sind, sonst `ok`.
2. Baue `$Lines` aus drei Aufrufen der Funktion, für dieselben drei Server und Werte.
3. Der Formattext mit `-f` darf nur einmal in der Datei vorkommen.

Die Funktion darf nur ihre Parameter benutzen.
