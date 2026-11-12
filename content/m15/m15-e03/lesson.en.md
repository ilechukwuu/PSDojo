# Dates as text

A date object has no layout. Only when it is turned into text does someone have to decide
between 14.03.2026, 3/14/2026 and 2026-03-14. If you do not decide, the language of the
system does, and the same script writes different texts on two servers.

**Writing.** `ToString` with a layout always gives the same text. The letters are
case-sensitive:

- `yyyy` year, `MM` month, `dd` day
- `HH` hour in 24-hour form, `mm` minute, `ss` second

Lower-case `mm` is minutes, upper-case `MM` is months. For file names and logs use
`yyyy-MM-dd` or `yyyyMMdd-HHmm`: such names sort correctly by themselves.

**Reading.** A cast with `[datetime]` only understands year-month-day safely. For any other
layout say exactly what you expect:
`[datetime]::ParseExact('14.03.2026', 'dd.MM.yyyy', $null)`. If the text does not fit, you
get an error instead of a wrong date.

## Example

```powershell
$Now = Get-Date
$Now.ToString('yyyy-MM-dd')
$Now.ToString('yyyyMMdd-HHmm')

[datetime]::ParseExact('14.03.2026', 'dd.MM.yyyy', $null)
```

The last line returns a real date object for 14 March 2026.
