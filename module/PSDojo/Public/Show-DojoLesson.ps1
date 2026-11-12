function Show-DojoLesson {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [string]$Id
    )

    $progress = Read-DojoProgress
    $state = Resolve-DojoExercise -Progress $progress -Id $Id
    if (-not $state) {
        return
    }
    $exercise = $state.Exercise
    $language = Get-DojoLanguage

    $record = Get-DojoExerciseRecord -Progress $progress -Id $exercise.Id
    Update-DojoActivity -Record $record
    Save-DojoProgress -Progress $progress

    Write-DojoLine
    Write-DojoLine -Text ('{0}  {1}  [{2}]' -f $exercise.Id, (Get-DojoLocalText -Table $exercise.Title), (Get-DojoString -Key ('Type_' + $exercise.Type))) -Color Cyan
    Write-DojoRule
    Write-DojoMarkdown -Markdown (Get-DojoExerciseText -Exercise $exercise -Kind 'lesson' -Language $language)
    Write-DojoLine
    Write-DojoRule
    Write-DojoMarkdown -Markdown (Get-DojoExerciseText -Exercise $exercise -Kind 'task' -Language $language)

    if ($exercise.Type -eq 'quiz') {
        $letters = 'abcdefgh'
        foreach ($question in (Get-DojoQuiz -Exercise $exercise)) {
            Write-DojoLine
            Write-DojoLine -Text ('{0}. {1}' -f $question['id'], $question['text'][$language])
            $index = 0
            foreach ($option in @($question['options'][$language])) {
                Write-DojoLine -Text ('   {0}) {1}' -f $letters[$index], $option)
                $index++
            }
        }
    }

    Write-DojoLine
    Write-DojoRule
    Write-DojoField -Label (Get-DojoString -Key 'LabelFile') -Value (Get-DojoLearnerFile -Exercise $exercise)
    Write-DojoField -Label (Get-DojoString -Key 'LabelNext') -Value (Get-DojoString -Key 'NextAfterLesson')
    Write-DojoLine
}
