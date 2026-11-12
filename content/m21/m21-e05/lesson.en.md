# Format mistakes

**The wrong delimiter.** A file with semicolons read without `-Delimiter` has a single
column whose name is the whole header line, `Server;Drive;FreeGB`. The symptom: the
properties you expect are empty, and no error appears.

**Calculating with CSV text.** A total built with `+` joins the values. The symptom: a
number that is far too large and has too many digits.

**JSON without depth.** Nested parts turn into a type name. The symptom: the file contains
`System.Object[]` or `@{...}` where data should be.

All three have something in common: the script runs to the end and writes a file. The
mistake is only visible in the content.

So check a data pipeline at its edges. After reading, look at the first object with
`Format-List -Property *`. After writing, read the file back and compare one value you
know.

## Example

```powershell
$Rows = Import-Csv -Path disks.csv -Delimiter ';'
$Rows[0] | Format-List -Property *

$Total = ($Rows | Measure-Object -Property FreeGB -Sum).Sum
```

Line 2 shows at a glance whether the columns were recognised.
