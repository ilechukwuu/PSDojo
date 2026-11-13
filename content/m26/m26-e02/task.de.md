# Aufgabe

Das Sicherungsteam bekommt immer wieder Pläne mit einer Aufbewahrung von 0 Tagen oder einem
Typ namens "weekly". Die Funktion, die einen Sicherungsplan beschreibt, muss solche Eingaben
selbst ablehnen.

Definiere eine Funktion `Get-BackupPlan` mit `[CmdletBinding()]` und drei Parametern:

1. `$ComputerName`: Pflicht, Text. Erlaubt sind nur Namen der Form `FS-`, `APP-` oder `WEB-`,
   gefolgt von genau zwei Ziffern.
2. `$Type`: Text, Standardwert `Full`. Erlaubt sind nur `Full`, `Differential` und `Log`.
3. `$RetentionDays`: ganze Zahl, Standardwert 14. Erlaubt sind nur Werte von 1 bis 90.

Die Funktion liefert ein Objekt mit den Eigenschaften `ComputerName`, `Type` und
`RetentionDays`.
