# Task

A capacity report shows the fullest server at the bottom and an absurd total. The data comes
from this CSV file:

```powershell
Server,FreeGB
FS-01,100
FS-02,20
FS-03,9
```

And from this JSON text: `{ "name": "FS-01", "freeGB": 100, "label": "100" }`

Predict the results. Do not run anything. `$Rows` is the result of `Import-Csv`, `$Item`
the result of `ConvertFrom-Json`.

1. `($Rows | Sort-Object -Property FreeGB)[0].Server` Store the server in `$Result1`.
2. `($Rows | Sort-Object -Property { [int]$_.FreeGB })[0].Server` Store it in `$Result2`.
3. `$Rows[0].FreeGB + $Rows[1].FreeGB` Store the result with its real type in `$Result3`.
4. `($Rows | Measure-Object -Property FreeGB -Sum).Sum` Store the number in `$Result4`.
5. `$Item.freeGB + $Item.freeGB` Store the result with its real type in `$Result5`.
