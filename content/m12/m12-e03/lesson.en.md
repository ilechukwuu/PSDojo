# Casting

Instead of hoping that PowerShell converts the right way, say what you want. A type in
square brackets in front of a value converts it. This is called a cast.

- `[int]'81'` gives the number 81.
- `[double]'81.5'` gives 81.5.
- `[datetime]'2026-03-14'` gives a date. Write dates as year-month-day, that format is
  understood everywhere, whatever the language of the system.
- `[string]445` gives the text 445.

If the conversion is impossible, for example `[int]'twelve'`, you get an error at once.
That is good: the script stops where the bad data is, not three steps later.

A type in front of the variable name goes further. `[int]$Count = '12'` converts now and
makes the variable keep that type. Everything assigned to it later is converted too, or
rejected.

## Example

```powershell
$UsedText = '81'
$Used = [int]$UsedText
$Used + 1

[datetime]$Start = '2026-03-14'
$Start.AddDays(7)
```

Line 3 returns 82. Line 6 can calculate because `$Start` is a real date.
