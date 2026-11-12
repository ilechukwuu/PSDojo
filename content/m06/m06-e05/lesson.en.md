# Static members

Until now every property and method belonged to an object: this file, that date. Some
belong to the type itself. They are called static, and you reach them with the type name in
square brackets and two colons.

- `[math]::Round(81.3749, 1)` rounds to one decimal place. `[math]::Max(a, b)` returns the
  larger of two numbers.
- `[datetime]::Today` is today at midnight, `[datetime]::Now` is this very moment.
- `[System.IO.Path]::GetExtension('usage.csv')` takes a file name apart without the file
  having to exist.
- `[Environment]::MachineName` is the name of the computer.

The rule for parentheses is the same as before: static methods need them, static properties
do not.

`Get-Member -Static` lists the static members of a type.

## Example

```powershell
[math]::Round(81.3749, 1)
[math]::Max(42, 310)
[datetime]::Today
[System.IO.Path]::GetExtension('usage-2026-03.csv')

Get-Date | Get-Member -Static
```

The first four lines return 81.4, 310, today's date and .csv. The last line lists what the
type DateTime offers without an object.
