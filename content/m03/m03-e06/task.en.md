# Task

A cleanup script for the scan folder on FS-02 is planned. Before it is written you check
three parameters of `Remove-Item`. This is what the help shows:

```powershell
-Path <string[]>
    Required?                    true
    Position?                    0
    Accept pipeline input?       true (ByValue, ByPropertyName)
    Accept wildcard characters?  true

-LiteralPath <string[]>
    Required?                    true
    Position?                    Named
    Accept wildcard characters?  false

-Recurse [<SwitchParameter>]
    Required?                    false
    Position?                    Named
    Default value                False
```

1. A folder is named `Scans[old]`. Square brackets are wildcard characters. Which of the two
   path parameters takes that name literally? Store its name in `$SafeParameter`.
2. May `-LiteralPath` be given without its name? Store `$true` or `$false` in
   `$LiteralIsPositional`.
3. What happens to subfolders when `-Recurse` is left out: are they included? Store `$true`
   or `$false` in `$IncludesSubfolders`.
