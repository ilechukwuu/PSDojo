# Task

The command `Get-Volume` on file server FS-02 returns four volumes in this order:

```powershell
DriveLetter FreeGB
----------- ------
C               42
D              310
E                8
F              125
```

Predict the results without running anything.

1. `Get-Volume | Sort-Object -Property FreeGB | Select-Object -First 1`
   Which drive letter comes out? Store it as text in `$FirstResult`.
2. `Get-Volume | Select-Object -First 2 | Sort-Object -Property FreeGB -Descending`
   Which drive letter is first in the result? Store it in `$SecondResult`.
3. `Get-Volume | Sort-Object -Property FreeGB -Descending | Select-Object -First 3 | Measure-Object`
   Which number is in the property Count? Store it in `$ThirdResult`.
