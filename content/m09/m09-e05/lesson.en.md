# Typical mistakes with Select-Object

Three mistakes account for most broken reports.

**Using a property that was not selected.** Everything after `Select-Object -Property` sees
only the new, narrow objects. Sorting or filtering by a property that was left out sorts or
filters by nothing, without an error. Either do that work before selecting or use the new
property.

**An expression without braces.** `Expression = $_.WorkingSet64 / 1MB` is calculated at
once, while `$_` is still empty. PowerShell then complains that the key Expression has an
invalid value. The value has to be a script block: `Expression = { ... }`.

**Objects where text was wanted.** `Select-Object -Property Name` returns objects. Joined
to a text they look like `@{Name=excel}`. For a plain list of values use
`-ExpandProperty`.

## Example

```powershell
Get-Process | Select-Object -Property Name | Sort-Object -Property WorkingSet64

Get-Process | Sort-Object -Property WorkingSet64 | Select-Object -Property Name
```

Line 1 sorts by a property that no longer exists, the order is meaningless. Line 3 sorts
first and selects afterwards.
