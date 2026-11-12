# Aufgabe

Beim Morgencheck auf dem Anwendungsserver APP-01 sortierst du die Dienste in drei Listen.
Jedes Dienstobjekt hat die Eigenschaften `Name`, `Status` und `StartType`.

1. Speichere die Dienste, deren `Status` `Stopped` ist, in `$Stopped`.
2. Speichere die Dienste, deren `StartType` nicht `Disabled` ist, in `$NotDisabled`.
3. Speichere die Dienste, deren `Status` `Running` ist, in `$Running`.

Jede Zeile ist `Get-Service`, geleitet in `Where-Object` mit einer Bedingung in Klammern.
