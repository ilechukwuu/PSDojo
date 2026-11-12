function Start-Dojo {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [string]$Id,

        [Parameter()]
        [ValidateSet('de', 'en')]
        [string]$Language
    )

    $dojoHome = Get-DojoHome
    if (-not (Test-Path -LiteralPath $dojoHome)) {
        [void](New-Item -Path $dojoHome -ItemType Directory -Force)
    }
    $progress = Read-DojoProgress
    if ($Language) {
        $progress['language'] = $Language
        $script:DojoLanguageOverride = $Language
    }

    $exercises = @(Get-DojoExerciseList)
    if ($exercises.Count -eq 0) {
        Save-DojoProgress -Progress $progress
        Write-DojoLine -Text (Get-DojoString -Key 'NoExercises' -Values (Get-DojoContentRoot)) -Color Yellow
        return
    }

    $copied = 0
    foreach ($exercise in $exercises) {
        $target = Get-DojoLearnerFile -Exercise $exercise
        if (-not (Test-Path -LiteralPath $target)) {
            $folder = Split-Path -Path $target -Parent
            if (-not (Test-Path -LiteralPath $folder)) {
                [void](New-Item -Path $folder -ItemType Directory -Force)
            }
            Copy-Item -LiteralPath (Join-Path -Path $exercise.Path -ChildPath 'starter.ps1') -Destination $target
            $copied++
        }
    }

    $states = @(Get-DojoExerciseState -Progress $progress -Exercises $exercises)
    $current = $null
    if ($Id) {
        $current = $states | Where-Object { $_.Id -eq $Id } | Select-Object -First 1
        if (-not $current) {
            Write-DojoLine -Text (Get-DojoString -Key 'UnknownExercise' -Values $Id) -Color Yellow
            return
        }
        if ($current.State -eq 'locked') {
            Write-DojoLine -Text (Get-DojoString -Key 'Locked' -Values $Id, ($current.Missing -join ', ')) -Color Yellow
            return
        }
    }
    else {
        $current = $states | Where-Object { $_.Id -eq $progress['current'] -and $_.State -eq 'open' } | Select-Object -First 1
        if (-not $current) {
            $current = $states | Where-Object { $_.State -eq 'open' } | Select-Object -First 1
        }
    }

    $done = @($states | Where-Object { $_.State -eq 'completed' }).Count
    Write-DojoLine
    Write-DojoLine -Text (Get-DojoString -Key 'Welcome') -Color Cyan
    Write-DojoRule
    Write-DojoField -Label (Get-DojoString -Key 'LabelFolder') -Value $dojoHome
    Write-DojoField -Label (Get-DojoString -Key 'LabelStatus') -Value (Get-DojoString -Key 'StatusLine' -Values $exercises.Count, $done, $copied)

    if (-not $current) {
        $progress['current'] = ''
        Save-DojoProgress -Progress $progress
        Write-DojoLine
        Write-DojoLine -Text ('  ' + (Get-DojoString -Key 'AllDone')) -Color Green
        return
    }

    $progress['current'] = $current.Id
    $record = Get-DojoExerciseRecord -Progress $progress -Id $current.Id
    Update-DojoActivity -Record $record
    Save-DojoProgress -Progress $progress

    Write-DojoLine
    Write-DojoLine -Text ('  ' + (Get-DojoString -Key 'NextExercise'))
    Write-DojoLine -Text ('  {0}  {1}  [{2}]' -f $current.Id, (Get-DojoLocalText -Table $current.Exercise.Title), (Get-DojoString -Key ('Type_' + $current.Exercise.Type))) -Color Cyan
    Write-DojoField -Label (Get-DojoString -Key 'LabelFile') -Value (Get-DojoLearnerFile -Exercise $current.Exercise)
    Write-DojoLine
    Write-DojoLine -Text ('  ' + (Get-DojoString -Key 'Commands'))
    foreach ($command in 'Show-DojoLesson', 'Test-Dojo', 'Get-DojoHint', 'Reset-DojoExercise', 'Show-DojoProgress') {
        Write-DojoLine -Text ('  {0,-20} {1}' -f $command, (Get-DojoString -Key ('Cmd_' + $command)))
    }
    Write-DojoLine
}
