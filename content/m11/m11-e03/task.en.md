# Task

A script named `check.ps1` contains these four lines:

```powershell
Write-Host 'Starting'
Write-Warning -Message 'Disk D: is 91 percent full'
Write-Output 'FS-02'
'FS-03'
```

Predict what happens. Do not run anything.

1. After `$Result = .\check.ps1`, how many items does `$Result` hold? Store the number in
   `$CapturedCount`.
2. After `$Result = .\check.ps1 3>&1`, how many items does `$Result` hold? Store the number
   in `$CapturedWithWarnings`.
3. Which stream number does `Write-Warning` write to? Store it in `$WarningStream`.
4. `.\check.ps1 3> warnings.log` Which of the four texts ends up in the file? Store the
   first word of that text in `$LoggedWord`.
