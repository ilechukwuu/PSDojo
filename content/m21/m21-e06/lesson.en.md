# Do not build CSV by hand

Writing a CSV file looks trivial: join the values with a semicolon and write the line. It
works until a value itself contains a semicolon, a quote or a line break. A description
like `Archive; old` then shifts every column to its right, and whoever reads the file gets
wrong data without any error.

The CSV format has rules for this: such values are put in quotes, and quotes inside them
are doubled. `Export-Csv` knows these rules, and `Import-Csv` reads the result back
exactly.

So the pattern is always the same:

1. Build objects with the properties that should become columns. `Select-Object` picks and
   orders them.
2. Pipe them into `Export-Csv`.

The same holds for JSON and XML. Never assemble a data format from text pieces when a
cmdlet can write it.

`ConvertTo-Csv` does the same as `Export-Csv` but returns the lines instead of writing a
file.

## Example

```powershell
$Disks |
    Select-Object -Property Server, Note, FreeGB |
    Export-Csv -Path report.csv -Delimiter ';' -NoTypeInformation -Encoding UTF8
```
