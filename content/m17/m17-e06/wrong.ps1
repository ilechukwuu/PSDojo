param($Root = '.')

# Log search for APP-01

$LogSearch = @{
    Path        = $Root
    Filter      = '*.log'
    File        = $true
    ErrorAction = 'Stop'
}
$Logs = Get-ChildItem @LogSearch
