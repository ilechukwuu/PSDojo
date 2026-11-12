function Get-DojoHint {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [string]$Id,

        [Parameter()]
        [switch]$Solution
    )

    $progress = Read-DojoProgress
    $state = Resolve-DojoExercise -Progress $progress -Id $Id
    if (-not $state) {
        return
    }
    $exercise = $state.Exercise
    $language = Get-DojoLanguage
    $record = Get-DojoExerciseRecord -Progress $progress -Id $exercise.Id
    $used = [int]$record['hints']
    Update-DojoActivity -Record $record

    Write-DojoLine
    if ($Solution) {
        if ($used -lt 3) {
            Save-DojoProgress -Progress $progress
            Write-DojoLine -Text ('  ' + (Get-DojoString -Key 'SolutionLocked' -Values $used)) -Color Yellow
            Write-DojoLine
            return
        }
        if ($record['status'] -ne 'completed') {
            $record['solutionViewed'] = $true
        }
        Save-DojoProgress -Progress $progress
        Write-DojoLine -Text (Get-DojoString -Key 'SolutionHeader' -Values $exercise.Id) -Color Cyan
        Write-DojoRule
        foreach ($line in (Get-Content -LiteralPath (Join-Path -Path $exercise.Path -ChildPath 'solution.ps1') -Encoding UTF8)) {
            Write-DojoLine -Text ('    ' + $line)
        }
        Write-DojoRule
        Write-DojoLine -Text ('  ' + (Get-DojoString -Key 'SolutionRecorded')) -Color Yellow
        Write-DojoLine
        return
    }

    $hints = Read-DojoJsonFile -Path (Join-Path -Path $exercise.Path -ChildPath 'hints.json')
    $levels = @($hints[$language])
    if ($used -ge 3) {
        Save-DojoProgress -Progress $progress
        for ($level = 1; $level -le 3; $level++) {
            Write-DojoField -Label (Get-DojoString -Key 'HintLabel' -Values $level) -Value $levels[$level - 1]
        }
        Write-DojoLine
        Write-DojoLine -Text ('  ' + (Get-DojoString -Key 'HintsUsedUp')) -Color Yellow
        Write-DojoLine
        return
    }

    $level = $used + 1
    if ($record['status'] -ne 'completed') {
        $record['hints'] = $level
    }
    Save-DojoProgress -Progress $progress
    Write-DojoField -Label (Get-DojoString -Key 'HintLabel' -Values $level) -Value $levels[$level - 1] -Color Cyan
    Write-DojoLine
    if ($level -lt 3) {
        Write-DojoLine -Text ('  ' + (Get-DojoString -Key 'HintMore' -Values (3 - $level)))
    }
    else {
        Write-DojoLine -Text ('  ' + (Get-DojoString -Key 'HintsUsedUp')) -Color Yellow
    }
    Write-DojoLine
}
