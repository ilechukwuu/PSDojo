# Task

Before a maintenance script for print server PRN-01 goes live you check how its pipelines
bind. The help for `Stop-Service` shows:

```powershell
-InputObject <ServiceController[]>
    Accept pipeline input?       true (ByValue)

-Name <string[]>
    Accept pipeline input?       true (ByValue, ByPropertyName)

-Force
    Accept pipeline input?       false
```

For each pipeline store the name of the parameter that receives the input, without the
hyphen. If nothing can bind, store the text `none`.

1. `Get-Service -Name Spooler | Stop-Service` in `$BindService`
2. `'Spooler' | Stop-Service` in `$BindText`
3. An object that has only the property `Name` with the value Spooler, piped into
   `Stop-Service`, in `$BindObject`
4. An object that has only the property `Service` with the value Spooler, piped into
   `Stop-Service`, in `$BindOther`
