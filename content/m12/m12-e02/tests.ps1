param($SolutionPath)

Describe 'Numbers of the capacity script' {
    BeforeAll {
        . $SolutionPath
    }

    It 'Result1: two texts are joined' {
        ($Result1 -is [string]) | Should -BeTrue -Because 'both values are text, so + joins them and the result is text, not a number'
        $Result1 | Should -Be '8139'
    }

    It 'Result2: a number on the left makes it a sum' {
        $Result2 | Should -Be 120 -Because '[int]$Used is a number, so the text on the right is converted to a number too'
        ($Result2 -is [int]) | Should -BeTrue -Because 'the result of adding two whole numbers is a whole number'
    }

    It 'Result3: text times a number repeats the text' {
        $Result3 | Should -Be '8181' -Because 'the left value is text, and text times 2 is the text twice'
    }

    It 'Result4: [int] rounds a half to the even number' {
        $Result4 | Should -Be 2 -Because '[int] rounds, and a half is rounded to the nearest even number'
    }

    It 'Result5: a non-empty text is true' {
        ($Result5 -is [bool]) | Should -BeTrue -Because 'the result of [bool] is $true or $false'
        $Result5 | Should -BeTrue -Because 'every text that is not empty counts as true, also the text 0'
    }
}
