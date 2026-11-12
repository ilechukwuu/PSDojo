# Date mistakes

**Comparing dates as text.** `'14.03.2026' -lt '02.04.2026'` compares character by
character. The 1 comes before the 0? No: 1 is after 0, so the comparison says the March date
is the later one. Text in day-month-year layout does not sort by time. Convert both sides to
dates first.

**Casting a German date.** `[datetime]'14.03.2026'` fails, because the cast reads month
first and there is no month 14. Worse, `[datetime]'03.04.2026'` works and gives 4 March.
Use `ParseExact`.

**The wrong direction.** A limit "30 days ago" written as `AddDays(30)` lies in the future.
Every date is then before the limit and everything counts as old.

Check a date calculation with one value you can verify by hand before you trust it with a
thousand accounts.

## Example

```powershell
$Expires = [datetime]::ParseExact('03.04.2026', 'dd.MM.yyyy', $null)
$WarnFrom = $Expires.AddDays(-30)
$Today = [datetime]'2026-03-14'
$Today -ge $WarnFrom
```

All three values are real dates. Line 4 is True: the warning period has begun.
