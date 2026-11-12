# Aufgabe

Drei Zeilen eines Berichtsskripts für APP-01 haben ein Format-Cmdlet an der falschen Stelle.
Behebe sie.

- `$Stopped` muss die sechs gestoppten Dienstobjekte enthalten, denn ein späterer Teil des
  Skripts startet sie neu.
- `$Names` muss die Namen aller zwölf Dienste als reinen Text enthalten.
- `$TopTable` wird nur einem Menschen gezeigt. Es muss eine formatierte Tabelle der zwei
  Prozesse mit dem höchsten `WorkingSet64` sein, den größten zuerst, mit den Spalten `Name`
  und `WorkingSet64`.
