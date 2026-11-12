# Aufgabe

Ein Backup-Bericht erreicht dich von einem deutschen System, und dein Skript schreibt eigene
Log- und Archivdateien. Die ersten Zeilen deiner Übungsdatei enthalten die Daten. Lass sie
unverändert.

1. Speichere `$Started` als Text im Aufbau `yyyy-MM-dd` in `$LogDate`.
2. Speichere `$Started` als Text im Aufbau `yyyyMMdd-HHmm` in `$Stamp`.
3. Speichere den Dateinamen `backup-20260314-2205.zip` in `$ArchiveName`, gebaut aus
   `$Stamp`.
4. Lies `$GermanDate`, das den Aufbau `dd.MM.yyyy` hat, in ein echtes Datum und speichere es
   in `$Expires`. Nutze `[datetime]::ParseExact`.
5. Speichere die Zahl der ganzen Tage von `$Started` bis `$Expires` in `$DaysLeft`.
