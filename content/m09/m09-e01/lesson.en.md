# Sort-Object and Select-Object

**Sort-Object** puts objects in order. Give it several properties and it sorts by the
first, and within equal values by the second. `-Descending` reverses, `-Unique` drops
duplicates.

**Select-Object** does two different jobs.

It limits how many objects pass: `-First 5`, `-Last 5`, `-Skip 1`.

And it chooses properties. Here two parameters look alike and are not:

- `-Property Name, Status` returns new objects that have only these properties. You still
  have objects and can go on working with `.Name`.
- `-ExpandProperty Name` returns the bare values, here a list of texts. Use it when the
  next step wants text, not objects.

Because `-Property` builds new, narrower objects, everything you did not select is gone for
the rest of the pipeline.

## Example

```powershell
Get-Service | Sort-Object -Property Status, Name
Get-Service | Select-Object -Property Name, Status
Get-Service | Select-Object -ExpandProperty Name
Get-Service | Select-Object -ExpandProperty StartType | Sort-Object -Unique
```

Line 2 returns objects with two properties. Line 3 returns names as text. Line 4 returns
every start type once.
