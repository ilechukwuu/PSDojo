# Task

A colleague wants to run these seven commands on file server FS-02 during business hours and
asks you to look over them first. Do not run anything. Answer from the names alone.

```powershell
Get-SmbShare
Get-Service -Name LanmanServer
Stop-Service -Name LanmanServer
Remove-SmbShare -Name Transfer
Get-Disk
Set-Service -Name Spooler -StartupType Disabled
New-SmbShare -Name Scans -Path D:\Scans
```

1. How many of the seven commands change the server? Store the number in `$ChangingCount`.
2. Which verb in the list only reads? Store it as text in `$ReadOnlyVerb`.
3. On a Windows server you run `Get-Command -Verb Restart -Noun Service`. It prints one row.
   What stands in the Name column? Store it as text in `$RestartCommand`.
