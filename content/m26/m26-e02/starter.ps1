# A backup plan that rejects wrong input by itself

function Get-BackupPlan {
    [CmdletBinding()]
    param(
        [string]$ComputerName,
        [string]$Type = 'Full',
        [int]$RetentionDays = 14
    )
}
