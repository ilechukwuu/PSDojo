function Show-DojoReviewItem {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Id,

        [Parameter()]
        [ValidateSet('de', 'en', 'both')]
        [string]$Language = 'both',

        [Parameter()]
        [switch]$SkipVerification
    )

    $exercise = Get-DojoReviewExercise -Id $Id
    if (-not $exercise) {
        return
    }
    $languages = @('de', 'en')
    if ($Language -ne 'both') {
        $languages = @($Language)
    }

    Write-DojoSection -Title "$($exercise.Id)  meta"
    Write-DojoField -Label 'Status' -Value $exercise.Status
    Write-DojoField -Label 'Type' -Value $exercise.Type
    Write-DojoField -Label 'Module' -Value ('{0}, order {1}' -f $exercise.Module, $exercise.Order)
    Write-DojoField -Label 'Requires' -Value ($exercise.Prerequisites -join ', ')
    Write-DojoField -Label 'Pass mark' -Value ('{0} percent' -f $exercise.PassMark)
    if ($exercise.MinPowerShell) {
        Write-DojoField -Label 'Min PS' -Value $exercise.MinPowerShell
    }
    if ($exercise.Requires.Count -gt 0) {
        Write-DojoField -Label 'Commands' -Value ($exercise.Requires -join ', ')
    }
    if ($exercise.Placeholder) {
        Write-DojoField -Label 'Note' -Value 'placeholder scenario' -Color Yellow
    }
    foreach ($code in $languages) {
        Write-DojoField -Label "Title $code" -Value $exercise.Title[$code]
        Write-DojoField -Label "Concept $code" -Value $exercise.Concept[$code]
    }

    foreach ($kind in 'lesson', 'task') {
        foreach ($code in $languages) {
            Write-DojoSection -Title "$kind.$code.md"
            Write-DojoMarkdown -Markdown (Get-DojoExerciseText -Exercise $exercise -Kind $kind -Language $code)
        }
    }

    $hints = Read-DojoJsonFile -Path (Join-Path -Path $exercise.Path -ChildPath 'hints.json')
    Write-DojoSection -Title 'hints.json'
    foreach ($code in $languages) {
        $level = 1
        foreach ($hint in @($hints[$code])) {
            Write-DojoField -Label "$code $level" -Value $hint
            $level++
        }
    }

    if ($exercise.Type -eq 'quiz') {
        Write-DojoSection -Title 'quiz.json'
        $letters = 'abcdefgh'
        foreach ($question in (Get-DojoQuiz -Exercise $exercise)) {
            foreach ($code in $languages) {
                Write-DojoLine
                Write-DojoLine -Text ('{0}. [{1}] {2}' -f $question['id'], $code, $question['text'][$code])
                $index = 0
                foreach ($option in @($question['options'][$code])) {
                    $mark = ' '
                    if ([string]$letters[$index] -eq $question['answer']) {
                        $mark = '*'
                    }
                    Write-DojoLine -Text ('  {0}{1}) {2}' -f $mark, $letters[$index], $option)
                    $index++
                }
            }
        }
    }

    foreach ($name in 'starter.ps1', 'solution.ps1', 'wrong.ps1', 'tests.ps1') {
        Write-DojoSection -Title $name
        Write-DojoCodeFile -Path (Join-Path -Path $exercise.Path -ChildPath $name)
    }

    if (-not $SkipVerification) {
        Write-DojoSection -Title 'verification'
        foreach ($check in (Test-DojoExerciseQuality -Exercise $exercise)) {
            $mark = 'FAIL'
            $color = 'Red'
            if ($check.Ok) {
                $mark = 'ok'
                $color = 'Green'
            }
            Write-DojoLine -Text ('  {0,-5} {1,-13} {2}' -f $mark, $check.Check, $check.Detail) -Color $color
        }
    }

    Write-DojoSection -Title 'review history'
    if ($exercise.ReviewHistory.Count -eq 0) {
        Write-DojoLine -Text '  no review yet'
    }
    foreach ($entry in $exercise.ReviewHistory) {
        $date = ConvertTo-DojoDate -Value $entry['timestamp']
        $stamp = ''
        if ($date) {
            $stamp = $date.ToLocalTime().ToString('yyyy-MM-dd HH:mm')
        }
        Write-DojoLine -Text ('  {0}  {1,-8} {2} -> {3}  {4}  {5}' -f $stamp, $entry['action'], $entry['from'], $entry['to'], $entry['reviewer'], $entry['comment'])
    }
    Write-DojoLine
    Write-DojoField -Label 'Next' -Value ("Approve-DojoExercise -Id {0}   or   Deny-DojoExercise -Id {0} -Comment '...'" -f $exercise.Id)
    Write-DojoLine
}
