# Finding files

`Get-ChildItem` lists what is in a folder. Four parameters turn it into a search:

- `-Recurse` goes down into every subfolder. Without it only the top level is listed.
- `-File` returns files only, `-Directory` folders only.
- `-Filter '*.log'` restricts by name. The provider does this filtering itself, which is
  much faster than `Where-Object` afterwards.
- `-Force` includes hidden items.

Each result is an object. For files the most used properties are `Name`, `FullName`,
`Extension`, `Length` (the size in bytes) and `LastWriteTime` (a date).

Age and size are therefore ordinary comparisons. Calculate the limit once, before the
pipeline, and compare with it. Sizes can be written with units: `100MB` is a number.

`Measure-Object -Property Length -Sum` adds up sizes.

## Example

```powershell
$Limit = (Get-Date).AddDays(-90)

$Old = Get-ChildItem -Path D:\Shares\Projects -Recurse -File -Filter '*.bak' |
    Where-Object { $_.LastWriteTime -lt $Limit -and $_.Length -gt 100MB }

($Old | Measure-Object -Property Length -Sum).Sum / 1GB
```
