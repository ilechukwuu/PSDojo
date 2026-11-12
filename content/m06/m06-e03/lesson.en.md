# Methods

A method is something an object can do. You call it like a property, but with parentheses
after the name. The parentheses are required even when they stay empty. Arguments go inside
them, separated by commas.

Methods you will use every week:

- On text: `ToUpper()`, `ToLower()`, `Trim()`, `Replace('old', 'new')`, `Split('.')`,
  `StartsWith('FS')`.
- On dates: `AddDays(30)`, `AddHours(-2)`, `ToString('yyyy-MM-dd')`.

Two rules save you from surprises.

Methods on text and dates return a new value. The original stays as it was, so you have to
store the result if you want to keep it.

Method names are not case-sensitive, but what they compare usually is: `Replace` and
`StartsWith` treat `fs` and `FS` as different.

The result of a method is an object again, so you can continue with another dot.

## Example

```powershell
$Server = 'FS-02.nordwind.example'
$Server.ToLower()
$Server.Split('.')[0]
(Get-Date -Year 2026 -Month 3 -Day 14).AddDays(30).Month
```

Line 3 splits at the dots and takes the first part, FS-02. Line 4 adds thirty days and reads
the month, 4.
