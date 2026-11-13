param($SolutionPath)

BeforeDiscovery {
    $quizFile = Join-Path -Path $PSScriptRoot -ChildPath 'quiz.json'
    $quiz = Get-Content -LiteralPath $quizFile -Raw -Encoding UTF8 | ConvertFrom-Json
    $questions = foreach ($question in $quiz.questions) {
        @{ Number = $question.id; Correct = $question.answer }
    }
}

Describe 'Quiz' {
    BeforeAll {
        . $SolutionPath
    }

    It 'Question <Number>' -ForEach $questions {
        $given = Get-Variable -Name "Answer$Number" -ValueOnly -ErrorAction SilentlyContinue
        ([string]$given).Trim().ToLower() | Should -Be $Correct
    }
}
