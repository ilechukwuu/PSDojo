# What goes wrong in production

A script reads the expiry dates of certificates from a CSV file and warns 30 days ahead:

```powershell
$Expires = [datetime]$Row.NotAfter
```

The file was exported on a German server, so the dates look like 03.04.2026. A cast always
reads the American way, month first. The third of April becomes the fourth of March, and
for 14.03.2026 the cast fails altogether. Half the warnings come a month early, the other
half never.

Never guess a date format. When you write dates for programs, write year-month-day. When
you read dates someone else wrote, say the layout with `[datetime]::ParseExact`.
