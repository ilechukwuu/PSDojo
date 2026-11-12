# Warning, verbose and the other streams

PowerShell has six streams. Each has a number and a cmdlet that writes to it.

1. Success: `Write-Output`, the result.
2. Error: `Write-Error`. Module 30 covers errors.
3. Warning: `Write-Warning`. Shown in yellow with the word WARNING in front. For things
   that deserve attention but do not stop the script.
4. Verbose: `Write-Verbose`. Hidden by default. For progress notes that help when you need
   to understand what a script is doing.
5. Debug: `Write-Debug`. Hidden by default, for developers.
6. Information: `Write-Information` and `Write-Host`.

Whether the hidden streams appear is decided by preference variables. Setting
`$VerbosePreference = 'Continue'` switches verbose messages on for the session,
`'SilentlyContinue'` switches them off again.

That is why `Write-Verbose` beats `Write-Host` for progress notes: the reader chooses. Quiet
in normal operation, talkative when hunting a problem.

## Example

```powershell
Write-Verbose -Message 'Reading services from APP-01'
$Count = 3
Write-Warning -Message "Stopped automatic services: $Count"
```

Line 1 shows nothing unless verbose output is switched on. Line 3 always shows a warning.
