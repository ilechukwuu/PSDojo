# Check for TS-03

$Rows = [pscustomobject]@{ Name = 'spoolsv' }, [pscustomobject]@{ Name = 'lsass' }
$Running = $Rows | Get-Process

$Stamp = Get-Date | Get-Date -Format 'yyyyMMdd' | Out-Null
