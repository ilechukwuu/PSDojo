# Aufgabe

Die Rufbereitschaft will den Zustand der Dienste auf APP-01 als einfache Zeilen für eine
Chatnachricht. Jedes Dienstobjekt hat die Eigenschaften `Name`, `Status` und `StartType`.

1. Speichere einen Text pro Dienst, dessen Name mit `Nordwind` beginnt, in `$Lines`, in der
   Form `NordwindApi is Running`. Nutze `Get-Service -Name Nordwind*`, geleitet in
   `ForEach-Object`.
2. Speichere die Namen aller Dienste, die `Stopped` sind, in Großbuchstaben in
   `$StoppedNames`. Nutze eine Pipeline aus `Get-Service`, `Where-Object` und
   `ForEach-Object`.
