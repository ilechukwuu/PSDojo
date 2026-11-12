# Task

A backup report reaches you from a German system, and your script writes its own log and
archive files. The first lines of your exercise file hold the data. Leave them as they are.

1. Store `$Started` as text in the layout `yyyy-MM-dd` in `$LogDate`.
2. Store `$Started` as text in the layout `yyyyMMdd-HHmm` in `$Stamp`.
3. Store the file name `backup-20260314-2205.zip` in `$ArchiveName`, built from `$Stamp`.
4. Read `$GermanDate`, which has the layout `dd.MM.yyyy`, into a real date and store it in
   `$Expires`. Use `[datetime]::ParseExact`.
5. Store the number of whole days from `$Started` until `$Expires` in `$DaysLeft`.
