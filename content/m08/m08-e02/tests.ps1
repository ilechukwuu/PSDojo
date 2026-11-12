param($SolutionPath)

Describe 'Comparisons in the disk report' {
    BeforeAll {
        . $SolutionPath
        $allBoolean = @($Result1, $Result2, $Result3, $Result4, $Result5, $Result6 | Where-Object { $_ -is [bool] }).Count -eq 6
    }

    It 'Every answer is true or false' {
        $allBoolean | Should -BeTrue -Because 'each answer is $true or $false, not text and not empty'
    }

    It 'Result1: text is compared without regard to case' {
        $Result1 | Should -BeTrue -Because '-eq ignores upper and lower case'
    }

    It 'Result2: two texts are compared character by character' {
        $Result2 | Should -BeFalse -Because 'both sides are text, and the character 1 comes before the character 2'
    }

    It 'Result3: a number on the left makes it a number comparison' {
        $Result3 | Should -BeTrue -Because 'the left value is a number, so 25 is converted to a number too'
    }

    It 'Result4: -eq does not understand wildcards' {
        $Result4 | Should -BeFalse -Because 'with -eq the star is an ordinary character'
    }

    It 'Result5: -like understands wildcards' {
        $Result5 | Should -BeTrue -Because 'the question mark stands for one character and the star for the rest'
    }

    It 'Result6: -contains ignores case' {
        $Result6 | Should -BeTrue -Because '-contains compares like -eq, without regard to case'
    }
}
