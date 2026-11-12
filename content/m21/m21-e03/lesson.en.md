# What the formats keep and what they lose

**CSV keeps no types.** Every value comes back as text, whatever it was before. The
consequences show up later and quietly:

- Comparing: `'100' -lt '20'` is true, because 1 comes before 2.
- Sorting: 100, 20 and 9 sort as 100, 20, 9.
- Adding with `+` joins the texts.
- `Measure-Object -Sum` is an exception. It converts by itself and adds correctly.

To sort a text column as numbers, sort by an expression:
`Sort-Object -Property { [int]$_.FreeGB }`.

**JSON keeps types.** A number written without quotes comes back as a number, `true` as a
boolean. A number in quotes is text in JSON too.

**JSON loses depth.** `ConvertTo-Json` without `-Depth` converts two levels. What lies
below is replaced by a text. PowerShell 7 at least prints a warning. Windows PowerShell 5.1
does not.

## Example

```powershell
$Rows = Import-Csv -Path disks.csv
$Rows | Sort-Object -Property FreeGB
$Rows | Sort-Object -Property { [int]$_.FreeGB }
($Rows | Measure-Object -Property FreeGB -Sum).Sum
```

Line 2 sorts as text, line 3 as numbers. Line 4 is a correct sum.
