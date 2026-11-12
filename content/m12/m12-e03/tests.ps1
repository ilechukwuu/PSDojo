param($SolutionPath)

Describe 'One row of the capacity file' {
    BeforeAll {
        . $SolutionPath
    }

    It 'UsedGB and TotalGB are whole numbers' {
        ($UsedGB -is [int]) | Should -BeTrue -Because 'the text must be converted with [int], otherwise the variable still holds text'
        ($TotalGB -is [int]) | Should -BeTrue -Because 'the text must be converted with [int], otherwise the variable still holds text'
        $UsedGB | Should -Be 410
        $TotalGB | Should -Be 500
    }

    It 'UsedPercent is the used share in percent' {
        $UsedPercent | Should -Be 82 -Because '410 divided by 500 times 100 is 82'
    }

    It 'MeasuredAt is a date' {
        ($MeasuredAt -is [datetime]) | Should -BeTrue -Because '[datetime] turns the text into a date object'
        $MeasuredAt.ToString('yyyy-MM-dd') | Should -Be '2026-03-14'
    }

    It 'NextCheck is seven days later' {
        ([datetime]$NextCheck).ToString('yyyy-MM-dd') | Should -Be '2026-03-21' -Because 'a real date can calculate with AddDays(7)'
    }
}
