param($SolutionPath)

Describe 'The alert that flags the wrong volumes' {
    BeforeAll {
        . $SolutionPath
    }

    It 'Result1: 12 is not below 10' {
        ($Result1 -is [bool]) | Should -BeTrue -Because 'a comparison returns $true or $false'
        $Result1 | Should -BeFalse -Because 'at the first call $Limit is 10'
    }

    It 'Result2: the block reads the changed limit' {
        $Result2 | Should -BeTrue -Because 'a block looks up outer variables when it is invoked, and $Limit is 20 by then'
    }

    It 'Result3: the closure keeps the limit of its creation' {
        $Result3 | Should -BeTrue -Because 'GetNewClosure() froze $Limit at 20. The later change to 5 does not reach the copy'
    }

    It 'Result4: the original block sees the newest limit' {
        ($Result4 -is [bool]) | Should -BeTrue -Because 'a comparison returns $true or $false'
        $Result4 | Should -BeFalse -Because 'the original block still reads from outside, where $Limit is now 5'
    }

    It 'Result5: a stored block does not run' {
        $Result5 | Should -Be 0 -Because 'defining a script block only stores the code. Without the call operator nothing is executed'
    }

    It 'Result6: every output is a result' {
        $Result6 | Should -Be 2 -Because 'the block outputs two texts, so the caller receives a list of two'
    }
}
