# Invented fixture data for the exercises. No name in here belongs to a real system.

function Get-DojoService {
    [CmdletBinding()]
    param(
        [Parameter()]
        [string[]]$Name
    )

    $rows = @(
        'Spooler|Print Spooler|Running|Automatic'
        'LanmanServer|Server|Running|Automatic'
        'W32Time|Windows Time|Stopped|Manual'
        'NordwindApi|Nordwind API|Running|Automatic'
        'NordwindSync|Nordwind Synchronisation|Stopped|Automatic'
        'NordwindPrint|Nordwind Print Connector|Stopped|Automatic'
        'BITS|Background Intelligent Transfer Service|Stopped|Manual'
        'WinRM|Windows Remote Management|Running|Automatic'
        'RemoteRegistry|Remote Registry|Stopped|Disabled'
        'wuauserv|Windows Update|Running|Manual'
        'MSSQLSERVER|SQL Server|Running|Automatic'
        'SQLSERVERAGENT|SQL Server Agent|Stopped|Automatic'
    )
    foreach ($row in $rows) {
        $parts = $row.Split('|')
        $isMatch = (-not $Name)
        foreach ($pattern in $Name) {
            if ($parts[0] -like $pattern) {
                $isMatch = $true
            }
        }
        if ($isMatch) {
            [pscustomobject]@{
                Name        = $parts[0]
                DisplayName = $parts[1]
                Status      = $parts[2]
                StartType   = $parts[3]
            }
        }
    }
}

function Get-DojoProcess {
    [CmdletBinding()]
    param(
        [Parameter()]
        [string[]]$Name
    )

    $rows = @(
        'sqlservr|1968|2048|412.5|Database'
        'excel|5544|1200|96.2|Office'
        'winword|6120|700|35.8|Office'
        'outlook|4980|500|61.4|Office'
        'spoolsv|2104|15|2.1|System'
        'rdpclip|5120|9|0.4|System'
    )
    foreach ($row in $rows) {
        $parts = $row.Split('|')
        $isMatch = (-not $Name)
        foreach ($pattern in $Name) {
            if ($parts[0] -like $pattern) {
                $isMatch = $true
            }
        }
        if ($isMatch) {
            [pscustomobject]@{
                Name         = $parts[0]
                Id           = [int]$parts[1]
                WorkingSet64 = [long]$parts[2] * 1MB
                CPU          = [double]::Parse($parts[3], [cultureinfo]::InvariantCulture)
                Category     = $parts[4]
            }
        }
    }
}
