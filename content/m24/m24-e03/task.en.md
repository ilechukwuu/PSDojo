# Task

An alert script flags volumes that are not low at all. Somewhere between the definition of
the rule and its use the threshold is changed. Predict the results. Do not run anything.

```powershell
$Limit = 10
$IsLow = { param($Value) $Value -lt $Limit }

$A = & $IsLow 12

$Limit = 20
$B = & $IsLow 12

$Frozen = $IsLow.GetNewClosure()
$Limit = 5
$C = & $Frozen 12
$D = & $IsLow 12

$Ping = { Test-Connection -ComputerName FS-01 -Count 1 }
$Servers = & { 'FS-01'; 'FS-02' }
```

1. Store the value of `$A` in `$Result1`.
2. Store the value of `$B` in `$Result2`.
3. Store the value of `$C` in `$Result3`.
4. Store the value of `$D` in `$Result4`.
5. How many times was FS-01 pinged by this script? Store the number in `$Result5`.
6. Store the value of `$Servers.Count` in `$Result6`.
