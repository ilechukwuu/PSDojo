# Task

A backup job for FS-02 started on 14 March 2026 at 22:00 and finished on 16 March 2026 at
04:30. A colleague wrote these lines for the report. Predict what they return. Do not run
anything.

```powershell
$Start = [datetime]'2026-03-14T22:00:00'
$End = [datetime]'2026-03-16T04:30:00'
$Duration = $End - $Start

$Duration.Days
$Duration.Hours
$Duration.TotalHours
$Start.DayOfWeek
([datetime]'2026-03-31').AddMonths(1).Day
```

Store the results of lines 5 to 9 in `$Result1` to `$Result5`. Store the weekday as text.
