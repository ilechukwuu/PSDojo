# Group-Object and Measure-Object

**Group-Object** sorts objects into piles by the value of a property. For each distinct
value you get one group object with three properties:

- `Name`: the value the group stands for.
- `Count`: how many objects are in it.
- `Group`: the objects themselves.

That answers questions like "how many services per status" in one line.

**Measure-Object** calculates with numbers. Tell it the property and what you want:
`-Sum`, `-Average`, `-Maximum`, `-Minimum`. The result is a single object with properties
of the same names, plus `Count`. Without any switch it only counts.

Sizes come in bytes. Dividing by `1MB` or `1GB` turns them into readable numbers, and
`[math]::Round()` removes the decimals.

## Example

```powershell
Get-Service | Group-Object -Property Status

$Memory = Get-Process | Measure-Object -Property WorkingSet64 -Sum -Maximum
[math]::Round($Memory.Sum / 1MB)
```

Line 1 returns one group per status with its count. Line 4 turns the sum of all working
sets into megabytes.
