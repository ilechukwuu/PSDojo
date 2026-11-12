$WatchList = [pscustomobject]@{ Name = 'spoolsv'; Owner = 'Print team' }, [pscustomobject]@{ Name = 'lsass'; Owner = 'Security' }
$LegacyList = [pscustomobject]@{ ProcessName = 'rdpclip' }, [pscustomobject]@{ ProcessName = 'backupagent' }
$AliasList = [pscustomobject]@{ Name = 'procs'; Value = 'Get-Process' }, [pscustomobject]@{ Name = 'items'; Value = 'Get-ChildItem' }

# Watch lists for TS-03

$Running = $WatchList | Get-Process
$Legacy = Get-Process

$AliasList | New-Alias -Force
