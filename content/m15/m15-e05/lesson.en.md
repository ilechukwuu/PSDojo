# Let the TimeSpan do the arithmetic

Scripts that grew over years often convert durations by hand: take the ticks or seconds,
divide by 60, divide by 60 again, divide by 24. Every one of those numbers is a chance for a
mistake, and a reader has to work out what 86400 or 10000000 means.

A TimeSpan already knows all of it.

- Subtract the start from the end and you have the duration.
- `TotalSeconds`, `TotalMinutes`, `TotalHours` and `TotalDays` give it in the unit you
  need.
- `[timespan]::FromSeconds(129600)` or `New-TimeSpan -Seconds 129600` turn a raw number
  from a log into a TimeSpan.

The code gets shorter, and it says what it means: total hours, not "divided by 3600".

## Example

```powershell
$Seconds = 129600
$Days = $Seconds / 60 / 60 / 24

$Days = [timespan]::FromSeconds($Seconds).TotalDays
$Hours = ($End - $Start).TotalHours
```

Lines 2 and 4 both give 1.5. Line 4 needs no explanation.
