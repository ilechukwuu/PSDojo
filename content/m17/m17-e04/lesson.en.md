# Behaviour worth knowing

**One table, two names.** Assigning a hashtable to a second variable does not make a copy.
Both variables refer to the same table. A change through one name is visible through the
other. The same is true for custom objects and Lists. If you need an independent copy of a
hashtable, call its method `Clone()`.

**Missing keys are quiet.** `$Table['nope']` returns `$null`, no error. A typo in a key
therefore looks like an empty value.

**Count belongs to the table.** `$Table.Count` is the number of pairs. A key that is itself
named Count has to be read with `$Table['Count']`.

**Order.** `[pscustomobject]` and `[ordered]@{ }` keep the order you wrote. A plain
`@{ }` does not promise any order.

## Example

```powershell
$A = @{ Site = 'Kiel' }
$B = $A
$B.Site = 'Hamburg'
$A.Site

$C = $A.Clone()
$C.Site = 'Bremen'
$A.Site
```

Line 4 returns Hamburg: `$A` and `$B` are the same table. Line 8 still returns Hamburg,
because `$C` is a copy.
