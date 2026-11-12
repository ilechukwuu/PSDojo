# Calculating with dates

Much of administration is a question about time. Which accounts have not been used for 90
days? Which files are older than a year? A date object can answer that itself.

**A date in the past or future.** The `Add` methods return a new date: `AddDays(30)`,
`AddMonths(-3)`, `AddHours(12)`. A negative number goes back. "90 days ago" is
`AddDays(-90)`.

**The distance between two dates.** Subtracting one date from another gives a TimeSpan, an
object that stands for a duration. Its property `Days` is the number of whole days, and
`TotalDays` is the same as a decimal number including the hours.

**Before or after.** Dates compare with the usual operators. Earlier is smaller:
`$LastLogon -lt $Limit` is true when the logon happened before the limit.

## Example

```powershell
$Today = Get-Date
$Limit = $Today.AddDays(-90)

$LastLogon = [datetime]'2025-11-02'
$Age = $Today - $LastLogon
$Age.Days
$LastLogon -lt $Limit
```

Line 6 is the number of days since the last logon. Line 7 says whether the account is older
than the limit.
