# Objects of your own

Commands return objects with properties, and everything in PowerShell is built to work with
those: filtering, sorting, exporting. When your script produces its own results it should
return the same kind of thing.

`[pscustomobject]` in front of a hashtable turns the pairs into properties:

`[pscustomobject]@{ Server = 'FS-02'; FreeGB = 75 }`

The differences to a plain hashtable matter:

- The properties keep the order in which you wrote them. That order becomes the column
  order of a table or CSV file.
- Every pipeline cmdlet understands the object. `Where-Object`, `Sort-Object`,
  `Export-Csv` and `Format-Table` see `Server` and `FreeGB`.
- Several such objects in an array form a table, like the result of any command.

Use a hashtable to look things up. Use a custom object for a row of data.

## Example

```powershell
$Rows = @(
    [pscustomobject]@{ Server = 'FS-01'; FreeGB = 120 }
    [pscustomobject]@{ Server = 'FS-02'; FreeGB = 8 }
)
$Rows | Where-Object { $_.FreeGB -lt 20 }
```

The last line returns the row for FS-02, as an object.
