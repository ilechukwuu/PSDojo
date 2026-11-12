# Task

On print server PRN-01 `Get-Service` returns these seven services:

```powershell
Name          Status  StartType
----          ------  ---------
Spooler       Running Automatic
LPDSVC        Stopped Manual
PrintNotify   Running Manual
WinRM         Running Automatic
BITS          Stopped Manual
W32Time       Stopped Manual
RemoteRegistry Stopped Disabled
```

Predict the results without running anything.

1. `Get-Service | Group-Object -Property StartType | Measure-Object` How many groups are
   counted? Store the number in `$GroupCount`.
2. `Get-Service | Group-Object -Property Status | Sort-Object -Property Count -Descending | Select-Object -First 1 -ExpandProperty Name`
   Which text comes out? Store it in `$LargestGroup`.
3. `(Get-Service | Sort-Object -Property StartType, Name | Select-Object -First 1).Name`
   Which name comes out? Store it in `$FirstName`.
4. `Get-Service | Select-Object -ExpandProperty Status | Sort-Object -Unique | Measure-Object`
   Which number is in Count? Store it in `$UniqueCount`.
