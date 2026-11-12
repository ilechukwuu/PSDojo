# Aufgabe

Ein Aufräumskript liest Einstellungen aus einer Textdatei, jede Einstellung kommt also als
Text an. Ein Kollege fragt, warum das Skript löscht, obwohl bei `Enabled` false steht. Sage
für jede Bedingung vorher, ob ihr Block läuft. Führe nichts aus.

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

Speichere `$true` in `$Runs1` bis `$Runs6`, wenn der Block läuft, sonst `$false`.
