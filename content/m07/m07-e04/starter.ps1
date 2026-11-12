# Check for TS-03. Both pipelines fail to bind.

$Rows = [pscustomobject]@{ Process = 'spoolsv' }, [pscustomobject]@{ Process = 'lsass' }
$Running = $Rows | Get-Process

$Stamp = 'yyyyMMdd' | Get-Date
