function Show-DojoProgress {
    [CmdletBinding()]
    param(
        [Parameter()]
        [switch]$PassThru
    )

    $progress = Read-DojoProgress
    $exercises = @(Get-DojoExerciseList)
    if ($exercises.Count -eq 0) {
        Write-DojoLine -Text (Get-DojoString -Key 'NoExercises' -Values (Get-DojoContentRoot)) -Color Yellow
        return
    }
    $states = @(Get-DojoExerciseState -Progress $progress -Exercises $exercises)
    $modules = @(Get-DojoModuleList)

    if ($PassThru) {
        foreach ($state in $states) {
            $record = Get-DojoExerciseRecord -Progress $progress -Id $state.Id
            [pscustomobject]@{
                PSTypeName     = 'PSDojo.ProgressRow'
                Module         = $state.Exercise.Module
                Id             = $state.Id
                State          = $state.State
                Type           = $state.Exercise.Type
                Attempts       = [int]$record['attempts']
                Hints          = [int]$record['hints']
                SolutionViewed = [bool]$record['solutionViewed']
                Seconds        = [int]$record['seconds']
                Current        = ($state.Id -eq $progress['current'])
                Title          = Get-DojoLocalText -Table $state.Exercise.Title
            }
        }
        return
    }

    $marks = @{ completed = '[x]'; open = '[ ]'; locked = '[-]'; unavailable = '[!]' }
    $colors = @{ completed = 'Green'; open = ''; locked = 'DarkGray'; unavailable = 'Yellow' }
    $done = @($states | Where-Object { $_.State -eq 'completed' }).Count

    Write-DojoLine
    Write-DojoLine -Text (Get-DojoString -Key 'ProgressHeader' -Values $done, $states.Count, $progress['learner']) -Color Cyan
    Write-DojoRule
    foreach ($module in $modules) {
        $own = @($states | Where-Object { $_.Exercise.Module -eq $module.Id })
        if ($own.Count -eq 0) {
            continue
        }
        $ownDone = @($own | Where-Object { $_.State -eq 'completed' }).Count
        Write-DojoLine -Text ('{0}  {1}  ({2}/{3})' -f $module.Id, (Get-DojoLocalText -Table $module.Title), $ownDone, $own.Count)
        foreach ($state in $own) {
            $mark = $marks[$state.State]
            $color = $colors[$state.State]
            if ($state.Id -eq $progress['current'] -and $state.State -eq 'open') {
                $mark = '[>]'
                $color = 'Cyan'
            }
            $line = '  {0} {1}  {2,-9} {3}' -f $mark, $state.Id, (Get-DojoString -Key ('Type_' + $state.Exercise.Type)), (Get-DojoLocalText -Table $state.Exercise.Title)
            if ($state.State -eq 'unavailable') {
                $line = $line + '  (' + $state.Reason + ')'
            }
            Write-DojoLine -Text $line -Color $color
        }
        Write-DojoLine
    }
    Write-DojoLine -Text (Get-DojoString -Key 'Legend')
    Write-DojoLine
}
