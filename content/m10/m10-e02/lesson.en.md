# Format right

A `Format-` cmdlet does not return your objects in a nicer shape. It returns a different
kind of object: instructions for drawing, such as "start a table", "here is a row", "end of
table". The services or processes themselves are gone.

Only the `Out-` cmdlets understand these instructions: `Out-Host` for the screen,
`Out-File` for a text file, `Out-String` for a text in memory.

Everything else chokes on them or, worse, runs without an error and produces rubbish.
`Where-Object` finds no property to compare. `Sort-Object` sorts nothing meaningful.
`Export-Csv` writes columns with cryptic names.

The rule is called format right: a `Format-` cmdlet is the last command of a pipeline, or
the last one before an `Out-` cmdlet. Sort, filter, select and calculate first.

`Get-Member` proves it at any time.

## Example

```powershell
Get-Service | Format-Table | Get-Member

Get-Service | Sort-Object -Property Name | Format-Table -Property Name, Status
```

Line 1 lists types with Format in their name, not ServiceController. Line 3 is the right
order: work first, draw last.
