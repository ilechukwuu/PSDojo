# Aufgabe

Das Skript in deiner Übungsdatei schreibt den wöchentlichen Datenträgerbericht als CSV, indem
es Textzeilen zusammenklebt. Eine Notiz mit einem Semikolon macht die Datei kaputt. Schreibe
es um.

1. Leite `$Disks` durch `Select-Object` mit den Eigenschaften `Server`, `Note` und `FreeGB`
   in `Export-Csv`.
2. Schreibe nach `report.csv` in `$Folder`, getrennt durch Semikolons, ohne die Typzeile,
   kodiert als UTF-8.
3. Kein `+` und kein `Set-Content` darf übrig bleiben.

Liest man die Datei mit `Import-Csv -Delimiter ';'` zurück, müssen die drei Zeilen mit ihren
drei Werten herauskommen. Lass die ersten Zeilen unverändert.
