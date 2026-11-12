# What goes wrong in production

A script restarts the application pools that a query returns and logs how many there were:

```powershell
$Pools = Get-IISAppPool | Where-Object { $_.State -eq 'Stopped' }
Write-Output "Restarting $($Pools.Count) pools, first: $($Pools[0].Name)"
```

On the test server three pools were stopped and everything worked. In production exactly
one is stopped. The query now returns a single object, not a list. In Windows PowerShell
5.1 `Count` of some single objects is empty, and with a single text `[0]` returns the first
letter. The log says "Restarting  pools".

A command returns nothing, one object or a list, depending on the data of the day. When
your code needs a list, make it one: `$Pools = @(...)`.
