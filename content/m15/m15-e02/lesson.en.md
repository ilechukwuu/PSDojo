# Days, TotalDays and month ends

A TimeSpan breaks a duration into parts: `Days`, `Hours`, `Minutes`, `Seconds`. A span of 36
hours has `Days` 1 and `Hours` 12. Each part is only its own share.

The `Total` properties are the whole duration in one unit: `TotalDays` 1.5, `TotalHours`
36, `TotalMinutes` 2160.

Mixing them up is a classic bug. A script that checks `$Age.Hours -gt 24` never fires,
because `Hours` is never more than 23. It should check `TotalHours`.

`New-TimeSpan` creates a span directly, for example `New-TimeSpan -Hours 36`.

**Months** are uneven, so `AddMonths` has a rule: when the target month does not have the
day, the result is the last day of that month. 31 January plus one month is 28 February, or
29 in a leap year.

`DayOfWeek` returns the weekday in English, whatever the language of the system.

## Example

```powershell
$Span = New-TimeSpan -Hours 36
$Span.Days
$Span.Hours
$Span.TotalHours
([datetime]'2026-01-31').AddMonths(1)
```

The results are 1, 12, 36 and 28 February 2026.
