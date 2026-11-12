# Task

A script validates server names and rewrites host names. Its author did not expect these
results. Predict them. Do not run anything.

```powershell
'fs-02' -match 'FS-\d\d'
'FS-0234' -match 'FS-\d\d'
'FS-0234' -match '^FS-\d\d$'
'FS-02_backup' -cmatch 'fs'
'web.nordwind.example' -replace '.', '_'
'web.nordwind.example' -replace '\.', '_'
'FS-02 and FS-17' -replace '\d+', '00'
```

Store the seven results in `$Result1` to `$Result7`. The first four are `$true` or
`$false`, the last three are texts.
