param($SolutionPath)

Describe 'Why the capacity report is wrong' {
    BeforeAll {
        . $SolutionPath
    }

    It 'Result1: sorted as text, 100 comes first' {
        ([string]$Result1).Trim() | Should -Be 'FS-01' -Because 'CSV values are text, and as text 100 comes before 20 and 9'
    }

    It 'Result2: sorted as numbers, 9 comes first' {
        ([string]$Result2).Trim() | Should -Be 'FS-03' -Because 'the expression converts each value with [int] before sorting'
    }

    It 'Result3: text plus text is joined' {
        ($Result3 -is [string]) | Should -BeTrue -Because 'both values are text, so the result is text'
        $Result3 | Should -Be '10020' -Because 'the plus sign joins two texts'
    }

    It 'Result4: Measure-Object converts by itself' {
        $Result4 | Should -Be 129 -Because 'Measure-Object -Sum turns the texts into numbers and adds them'
    }

    It 'Result5: JSON keeps the number' {
        ($Result5 -is [string]) | Should -BeFalse -Because 'a number without quotes in JSON comes back as a number'
        $Result5 | Should -Be 200
    }
}
