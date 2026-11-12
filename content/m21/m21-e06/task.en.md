# Task

The script in your exercise file writes the weekly disk report as CSV by gluing text lines
together. A note that contains a semicolon breaks the file. Rewrite it.

1. Pipe `$Disks` through `Select-Object` with the properties `Server`, `Note` and `FreeGB`
   into `Export-Csv`.
2. Write to `report.csv` in `$Folder`, separated by semicolons, without the type line,
   encoded as UTF-8.
3. No `+` and no `Set-Content` may remain.

Reading the file back with `Import-Csv -Delimiter ';'` must return the three rows with
their three values. Leave the first lines as they are.
