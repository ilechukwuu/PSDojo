# What goes wrong in production

A report script trims the output early to keep it tidy and decides later what to do:

```powershell
$Users = Get-ADUser -Filter * -Properties LastLogonDate | Select-Object -Property Name
$Users | Where-Object { $_.LastLogonDate -lt $Limit }
```

`Select-Object -Property Name` does not hide the other properties. It builds new objects
that have only a name. `LastLogonDate` is gone, the comparison sees an empty value for
every user, and an empty value is less than any date. Every account in the domain ends up
on the list of stale accounts.

Select properties at the end of a pipeline, when everything that needs the full object is
done.
