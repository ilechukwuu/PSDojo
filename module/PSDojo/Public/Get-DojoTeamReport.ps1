function Get-DojoTeamReport {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Path,

        [Parameter()]
        [switch]$ByModule
    )

    if (-not (Test-Path -LiteralPath $Path -PathType Container)) {
        Write-Error -Message (Get-DojoString -Key 'FolderMissing' -Values $Path) -Category ObjectNotFound
        return
    }

    $latest = @{}
    foreach ($file in (Get-ChildItem -LiteralPath $Path -Filter '*.json' -File -Recurse)) {
        try {
            $report = Read-DojoJsonFile -Path $file.FullName
        }
        catch {
            Write-Warning -Message (Get-DojoString -Key 'ReportUnreadable' -Values $file.FullName)
            continue
        }
        if (-not ($report -is [System.Collections.IDictionary]) -or $report['kind'] -ne 'PSDojoReport') {
            continue
        }
        $learner = [string]$report['learner']
        $generated = ConvertTo-DojoDate -Value $report['generatedAt']
        if (-not $latest.ContainsKey($learner) -or $generated -gt $latest[$learner].Generated) {
            $latest[$learner] = @{ Generated = $generated; Report = $report }
        }
    }

    if ($latest.Count -eq 0) {
        Write-Warning -Message (Get-DojoString -Key 'NoReports' -Values $Path)
        return
    }

    foreach ($learner in ($latest.Keys | Sort-Object)) {
        $report = $latest[$learner].Report
        $generated = $latest[$learner].Generated
        if ($ByModule) {
            foreach ($module in @($report['modules'])) {
                [pscustomobject]@{
                    PSTypeName      = 'PSDojo.TeamModuleRow'
                    Learner         = $learner
                    Module          = [string]$module['id']
                    Title           = [string]$module['title']
                    Completed       = [int]$module['completed']
                    Total           = [int]$module['total']
                    Attempts        = [int]$module['attempts']
                    Hints           = [int]$module['hints']
                    SolutionsViewed = [int]$module['solutionsViewed']
                    Minutes         = [Math]::Round([int]$module['seconds'] / 60, 1)
                }
            }
            continue
        }
        $totals = $report['totals']
        $percent = 0
        if ([int]$totals['exercises'] -gt 0) {
            $percent = [int][Math]::Round(100 * [int]$totals['completed'] / [int]$totals['exercises'], 0, [System.MidpointRounding]::AwayFromZero)
        }
        $stamp = ''
        if ($generated) {
            $stamp = $generated.ToLocalTime().ToString('yyyy-MM-dd HH:mm')
        }
        [pscustomobject]@{
            PSTypeName      = 'PSDojo.TeamReportRow'
            Learner         = $learner
            Completed       = [int]$totals['completed']
            Total           = [int]$totals['exercises']
            Percent         = $percent
            Attempts        = [int]$totals['attempts']
            Hints           = [int]$totals['hints']
            SolutionsViewed = [int]$totals['solutionsViewed']
            Hours           = [Math]::Round([int]$totals['seconds'] / 3600, 1)
            Generated       = $stamp
        }
    }
}
