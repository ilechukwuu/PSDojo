param($SolutionPath)

Describe 'Duration of the backup job' {
    BeforeAll {
        . $SolutionPath
    }

    It 'Result1: Days is the number of whole days' {
        $Result1 | Should -Be 1 -Because 'the job ran one whole day and a few hours'
    }

    It 'Result2: Hours is only the share after the whole days' {
        $Result2 | Should -Be 6 -Because 'Hours is the part that remains after the whole days, never more than 23'
    }

    It 'Result3: TotalHours is the whole duration in hours' {
        $Result3 | Should -Be 30.5 -Because '24 hours plus 6.5 hours is 30.5'
    }

    It 'Result4: DayOfWeek is the English weekday' {
        ([string]$Result4).Trim() | Should -Be 'Saturday' -Because '14 March 2026 is a Saturday, and DayOfWeek is always English'
    }

    It 'Result5: AddMonths lands on the last day of a shorter month' {
        $Result5 | Should -Be 30 -Because 'April has no 31st, so the result is the last day of April'
    }
}
