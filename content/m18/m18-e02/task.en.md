# Task

A cleanup script reads settings from a text file, so every setting arrives as text. A
colleague asks why the script deletes although `Enabled` says false. Predict for each
condition whether its block runs. Do not run anything.

```powershell
$Enabled = 'false'
$RetryCount = 0
$Servers = @()
$LastError = $null
$Owner = ' '

if ($Enabled) { 'block 1' }
if ($RetryCount) { 'block 2' }
if ($Servers) { 'block 3' }
if (-not $LastError) { 'block 4' }
if ($Owner) { 'block 5' }
if ($Enabled -eq 'true') { 'block 6' }
```

Store `$true` in `$Runs1` to `$Runs6` when the block runs, otherwise `$false`.
