param($SolutionPath)

Describe 'Which example calls work' {
    BeforeAll {
        . $SolutionPath
    }

    It 'Result1: the defaults are enough' {
        $Result1 | Should -BeTrue -Because 'only $Path is mandatory, the other two have defaults'
    }

    It 'Result2: ValidateSet ignores case' {
        ($Result2 -is [bool]) | Should -BeTrue -Because 'the answer is $true or $false'
        $Result2 | Should -BeTrue -Because 'ValidateSet compares without regard to upper and lower case, so warning is accepted'
    }

    It 'Result3: Debug is not in the set' {
        ($Result3 -is [bool]) | Should -BeTrue -Because 'the answer is $true or $false'
        $Result3 | Should -BeFalse -Because 'only Error, Warning and Info are allowed'
    }

    It 'Result4: the upper limit is included' {
        $Result4 | Should -BeTrue -Because 'ValidateRange(1, 1000) includes both limits'
    }

    It 'Result5: an unknown parameter is an error' {
        ($Result5 -is [bool]) | Should -BeTrue -Because 'the answer is $true or $false'
        $Result5 | Should -BeFalse -Because 'the function has no parameter -Lines, and with CmdletBinding an unknown name is rejected'
    }

    It 'Result6: the value is converted before it is validated' {
        $Result6 | Should -Be 3 -Because 'the type [int] rounds 2.7 to 3, and 3 lies within the range'
    }
}
