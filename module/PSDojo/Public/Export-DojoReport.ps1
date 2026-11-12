function Export-DojoReport {
    [CmdletBinding()]
    [OutputType([System.IO.FileInfo])]
    param(
        [Parameter(Position = 0)]
        [string]$Path
    )

    $progress = Read-DojoProgress
    $exercises = @(Get-DojoExerciseList)
    $states = @(Get-DojoExerciseState -Progress $progress -Exercises $exercises)
    $modules = @(Get-DojoModuleList)

    $exerciseRows = New-Object -TypeName System.Collections.ArrayList
    foreach ($state in $states) {
        $record = Get-DojoExerciseRecord -Progress $progress -Id $state.Id
        [void]$exerciseRows.Add([ordered]@{
                id             = $state.Id
                module         = $state.Exercise.Module
                type           = $state.Exercise.Type
                status         = $state.State
                attempts       = [int]$record['attempts']
                hints          = [int]$record['hints']
                solutionViewed = [bool]$record['solutionViewed']
                seconds        = [int]$record['seconds']
                completedAt    = [string]$record['completedAt']
            })
    }

    $moduleRows = New-Object -TypeName System.Collections.ArrayList
    foreach ($module in $modules) {
        $own = @($exerciseRows | Where-Object { $_['module'] -eq $module.Id })
        if ($own.Count -eq 0) {
            continue
        }
        [void]$moduleRows.Add([ordered]@{
                id              = $module.Id
                title           = $module.Title['en']
                total           = $own.Count
                completed       = @($own | Where-Object { $_['status'] -eq 'completed' }).Count
                attempts        = [int]($own | ForEach-Object { $_['attempts'] } | Measure-Object -Sum).Sum
                hints           = [int]($own | ForEach-Object { $_['hints'] } | Measure-Object -Sum).Sum
                solutionsViewed = @($own | Where-Object { $_['solutionViewed'] }).Count
                seconds         = [int]($own | ForEach-Object { $_['seconds'] } | Measure-Object -Sum).Sum
            })
    }

    $report = [ordered]@{
        kind        = 'PSDojoReport'
        schema      = 1
        learner     = [string]$progress['learner']
        machine     = [Environment]::MachineName
        generatedAt = Get-DojoTimestamp
        totals      = [ordered]@{
            exercises       = $exerciseRows.Count
            completed       = @($exerciseRows | Where-Object { $_['status'] -eq 'completed' }).Count
            attempts        = [int]($exerciseRows | ForEach-Object { $_['attempts'] } | Measure-Object -Sum).Sum
            hints           = [int]($exerciseRows | ForEach-Object { $_['hints'] } | Measure-Object -Sum).Sum
            solutionsViewed = @($exerciseRows | Where-Object { $_['solutionViewed'] }).Count
            seconds         = [int]($exerciseRows | ForEach-Object { $_['seconds'] } | Measure-Object -Sum).Sum
        }
        modules     = $moduleRows.ToArray()
        exercises   = $exerciseRows.ToArray()
    }

    $name = 'PSDojo-Report-{0}-{1}.json' -f ($progress['learner'] -replace '[^A-Za-z0-9._-]', '_'), [datetime]::Now.ToString('yyyyMMdd-HHmmss')
    if (-not $Path) {
        $Path = Join-Path -Path (Join-Path -Path (Get-DojoHome) -ChildPath 'reports') -ChildPath $name
    }
    elseif (Test-Path -LiteralPath $Path -PathType Container) {
        $Path = Join-Path -Path (Resolve-Path -LiteralPath $Path).ProviderPath -ChildPath $name
    }
    else {
        $Path = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Path)
    }

    Write-DojoTextFile -Path $Path -Text (ConvertTo-Json -InputObject $report -Depth 10)
    Write-DojoLine -Text (Get-DojoString -Key 'ReportWritten' -Values $Path)
    return (Get-Item -LiteralPath $Path)
}
