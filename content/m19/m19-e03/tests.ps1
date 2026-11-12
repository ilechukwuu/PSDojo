param($SolutionPath)

Describe 'Four loops from the patch script' {
    BeforeAll {
        . $SolutionPath
    }

    It 'ResultA: the for loop runs with 0, 3, 6 and 9' {
        $ResultA | Should -Be 4 -Because 'the step is 3, and 12 is no longer below 10'
    }

    It 'ResultB: the while loop runs until the queue is empty' {
        $ResultB | Should -Be 3 -Because 'the queue goes from 5 to 3 to 1 to -1, that is three passes'
    }

    It 'ResultC: a do loop runs at least once' {
        $ResultC | Should -Be 1 -Because 'the block runs before the condition is checked for the first time'
    }

    It 'ResultD: continue skips a pass, break ends the loop' {
        $ResultD | Should -Be 3 -Because 'the passes for 1, 3 and 4 count. 2 is skipped and at 5 the loop ends'
    }
}
