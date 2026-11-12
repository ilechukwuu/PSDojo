function Test-Dojo {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [string]$Id,

        [Parameter()]
        [switch]$PassThru
    )

    $progress = Read-DojoProgress
    $state = Resolve-DojoExercise -Progress $progress -Id $Id
    if (-not $state) {
        return
    }
    $exercise = $state.Exercise
    $record = Get-DojoExerciseRecord -Progress $progress -Id $exercise.Id
    $wasCompleted = ($record['status'] -eq 'completed')

    Update-DojoActivity -Record $record
    if (-not $wasCompleted) {
        $record['attempts'] = [int]$record['attempts'] + 1
    }
    Save-DojoProgress -Progress $progress

    Write-DojoLine -Text (Get-DojoString -Key 'Checking' -Values $exercise.Id)
    $result = Invoke-DojoCheck -Exercise $exercise -ScriptPath (Get-DojoLearnerFile -Exercise $exercise)
    Write-DojoCheckResult -Exercise $exercise -Result $result

    if ($result.Passed) {
        $exercises = @(Get-DojoExerciseList)
        if (-not $wasCompleted) {
            $record['status'] = 'completed'
            $record['completedAt'] = Get-DojoTimestamp
        }
        $states = @(Get-DojoExerciseState -Progress $progress -Exercises $exercises)
        $openInModule = @($states | Where-Object { $_.Exercise.Module -eq $exercise.Module -and $_.State -ne 'completed' })
        if (-not $wasCompleted -and $openInModule.Count -eq 0) {
            $module = Get-DojoModuleList | Where-Object { $_.Id -eq $exercise.Module } | Select-Object -First 1
            Write-DojoLine
            Write-DojoLine -Text ('  ' + (Get-DojoString -Key 'ModuleComplete' -Values (Get-DojoLocalText -Table $module.Title))) -Color Green
            $note = Join-Path -Path $module.Path -ChildPath "production.$(Get-DojoLanguage).md"
            if (Test-Path -LiteralPath $note) {
                Write-DojoLine
                Write-DojoMarkdown -Markdown (Get-Content -LiteralPath $note -Raw -Encoding UTF8)
            }
        }
        $next = $states | Where-Object { $_.State -eq 'open' } | Select-Object -First 1
        Write-DojoLine
        if ($next) {
            $progress['current'] = $next.Id
            Update-DojoActivity -Record (Get-DojoExerciseRecord -Progress $progress -Id $next.Id)
            Write-DojoField -Label (Get-DojoString -Key 'LabelNext') -Value ('{0}  {1}' -f $next.Id, (Get-DojoLocalText -Table $next.Exercise.Title))
            Write-DojoField -Label '' -Value (Get-DojoString -Key 'NextAfterPass')
        }
        else {
            $progress['current'] = ''
            Write-DojoLine -Text ('  ' + (Get-DojoString -Key 'AllDone')) -Color Green
        }
        Save-DojoProgress -Progress $progress
    }
    Write-DojoLine

    if ($PassThru) {
        return $result
    }
}
