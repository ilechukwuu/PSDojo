# What goes wrong in production

A script is supposed to disable accounts that have not logged on for 90 days:

```powershell
Get-ADUser -Filter * | Where-Object { $_.LastLogonDate -lt $Limit } | Disable-ADAccount
```

Service accounts and brand-new users have never logged on. Their `LastLogonDate` is empty,
and in PowerShell an empty value is less than any date. The filter lets them all through.
On Monday the backup, the SQL agent and two new colleagues are locked out.

A comparison with an empty value does not fail, it just gives an answer you did not think
about. When you filter on a property, decide on purpose what happens to objects where it is
empty, and look at the list before you pipe it into anything that changes something.
