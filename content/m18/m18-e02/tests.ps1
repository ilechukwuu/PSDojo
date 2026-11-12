param($SolutionPath)

Describe 'Which blocks of the cleanup script run' {
    BeforeAll {
        . $SolutionPath
        $allBoolean = @($Runs1, $Runs2, $Runs3, $Runs4, $Runs5, $Runs6 | Where-Object { $_ -is [bool] }).Count -eq 6
    }

    It 'Every answer is true or false' {
        $allBoolean | Should -BeTrue -Because 'each answer is $true or $false'
    }

    It 'Runs1: the text false is true' {
        $Runs1 | Should -BeTrue -Because 'a text that is not empty counts as true, whatever it says'
    }

    It 'Runs2: the number 0 is false' {
        $Runs2 | Should -BeFalse -Because 'the number 0 counts as false'
    }

    It 'Runs3: an empty array is false' {
        $Runs3 | Should -BeFalse -Because 'an array without elements counts as false'
    }

    It 'Runs4: -not $null is true' {
        $Runs4 | Should -BeTrue -Because '$null counts as false, and -not reverses that'
    }

    It 'Runs5: a text with one space is true' {
        $Runs5 | Should -BeTrue -Because 'a space is a character, so the text is not empty'
    }

    It 'Runs6: a real comparison' {
        $Runs6 | Should -BeFalse -Because 'the text false is not equal to the text true'
    }
}
