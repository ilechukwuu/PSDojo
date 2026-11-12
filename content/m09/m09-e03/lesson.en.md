# Know what flows

After `Sort-Object` and `Where-Object` the same objects come out that went in. After
`Select-Object`, `Group-Object` and `Measure-Object` something else comes out, and the next
command has to work with that.

- After `Select-Object -Property Name` you have objects with one property. Joining them as
  text gives `@{Name=Spooler}`, not `Spooler`.
- After `Select-Object -ExpandProperty Name` you have plain texts. They have no property
  `Name` any more, they are the names.
- After `Group-Object` you have group objects. Sorting by `Count` sorts the groups, and
  `Name` is the value they were grouped by.
- After `Measure-Object` you have exactly one object, however many went in.

When you are unsure, pipe the intermediate result into `Get-Member` and read the type name
at the top.

## Example

```powershell
Get-Service | Group-Object -Property Status | Sort-Object -Property Count -Descending |
    Select-Object -First 1 -ExpandProperty Name
```

Group by status, put the largest group first, keep one, and return its name as text: the
status that occurs most often.
