# Aufgabe

Erweitere die Prüfung für APP-01 so, dass sie Probleme sauber meldet.

1. Schreibe die Verbose-Meldung `Reading services from APP-01`.
2. Speichere die Dienste, die `Stopped` sind und den `StartType` `Automatic` haben, in
   `$Broken`.
3. Speichere die Anzahl dieser Dienste in `$Count`. `@($Broken).Count` liefert sie.
4. Schreibe eine Warnung mit dem Text `Stopped automatic services: ` und danach der Zahl,
   zum Beispiel `Stopped automatic services: 3`.
5. Liefere die Namen der Dienste in `$Broken` als Ergebnis des Skripts.
