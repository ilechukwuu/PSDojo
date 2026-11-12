param($SolutionPath)

Describe 'Expressions from the disk monitoring' {
    BeforeAll {
        . $SolutionPath
    }

    It 'Result1: division before addition' {
        $Result1 | Should -Be 80.2 -Because 'the division 20 / 100 is done before the addition'
    }

    It 'Result2: parentheses first' {
        $Result2 | Should -Be 1 -Because 'the parentheses make the addition happen first, and 100 / 100 is 1'
    }

    It 'Result3: arithmetic before comparison' {
        ($Result3 -is [bool]) | Should -BeTrue -Because 'a comparison returns $true or $false'
        $Result3 | Should -BeTrue -Because '100 - 80 is calculated first, and 20 is less than 25'
    }

    It 'Result4: -or and -and from left to right' {
        ($Result4 -is [bool]) | Should -BeTrue -Because 'the result is $true or $false'
        $Result4 | Should -BeFalse -Because '-or and -and have the same rank, so it is (False -or True) -and False'
    }

    It 'Result5: -not reverses' {
        $Result5 | Should -BeTrue -Because '80 is not greater than 90, and -not turns that False into True'
    }
}
