# Aufgabe

Der Helpdesk bekommt eine Funktion, die beschreibt, welche Freigabe welches Dateiservers
gemessen werden soll. Ohne Servernamen muss sie den Dienst verweigern, und sie muss still
sein, solange niemand fragt.

Definiere eine Funktion `Get-ShareUsage`:

1. Sie trägt `[CmdletBinding()]`.
2. Sie hat einen Pflichtparameter `$ComputerName` (Text) und einen Parameter `$Share` (Text)
   mit dem Standardwert `Data`.
3. Sie schreibt die Meldung `Reading share <Share> on <ComputerName>` mit `Write-Verbose`,
   mit den zwei eingesetzten Werten.
4. Sie liefert ein Objekt mit den Eigenschaften `ComputerName` und `Share`.
