param($Root = '.')

# Log search for APP-01

$LogSearch = @{
    Path        = $Root
    Filter      = '*.log'
    Recurse     = $true
    File        = $true
    ErrorAction = 'Stop'
}
$Logs = Get-ChildItem @LogSearch
