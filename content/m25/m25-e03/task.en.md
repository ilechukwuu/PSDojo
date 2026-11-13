# Task

A colleague who comes from another programming language has written helper functions for
the inventory. Their results are "sometimes strange". Predict what comes back. Do not run
anything.

```powershell
function Get-ServerCount {
    $List = New-Object -TypeName System.Collections.ArrayList
    $List.Add('FS-01')
    $List.Add('FS-02')
    return $List.Count
}

function Get-FirstFileServer {
    param($Names)
    foreach ($Name in $Names) {
        if ($Name -like 'FS-*') { return $Name }
    }
    'none'
}

function Join-Name {
    param($Site, $Server)
    "$Site|$Server"
}
```

1. `@(Get-ServerCount).Count` Store the number in `$Result1`.
2. `(Get-ServerCount)[2]` Store the value in `$Result2`.
3. `Get-FirstFileServer -Names 'PRN-01', 'FS-02', 'FS-03'` Store the result in `$Result3`.
4. `Join-Name -Site 'Kiel' -Server 'FS-01'` Store the text in `$Result4`.
5. `Join-Name('Kiel', 'FS-01')` Store the text in `$Result5`.
