# CSV

CSV is the format of spreadsheets and exports: one line per record, the values separated by
a character, the first line holding the column names.

`Import-Csv` reads such a file and returns one object per line. The column names become
property names. From there on everything you know about objects applies.

Two things cause most trouble:

- **Everything is text.** A column of numbers arrives as texts. Convert with `[int]` before
  you compare or calculate.
- **The separator.** The default is a comma. Excel on a German system writes semicolons.
  Say which one with `-Delimiter ';'`, when reading and when writing.

`Export-Csv` writes objects to a file, one column per property. Windows PowerShell 5.1 puts
a line starting with `#TYPE` at the top unless you add `-NoTypeInformation`. PowerShell 7
leaves it out by itself. Add the switch and both behave alike. `-Encoding UTF8` keeps
umlauts intact.

## Example

```powershell
$Rows = Import-Csv -Path D:\Reports\disks.csv -Delimiter ';'
$Low = $Rows | Where-Object { [int]$_.FreeGB -lt 20 }
$Low | Export-Csv -Path D:\Reports\low.csv -Delimiter ';' -NoTypeInformation -Encoding UTF8
```
