param($SolutionPath)

Describe 'Work queue of the patch night' {
    BeforeAll {
        . $SolutionPath | Out-Null
    }

    It 'Done holds both finished servers' {
        @($Done) -join ', ' | Should -Be 'FS-01, FS-02' -Because '+= appends an element to the array'
    }

    It 'Queue is a generic List' {
        $type = if ($null -eq $Queue) { 'nothing' } else { $Queue.GetType().Name }
        $type | Should -Be 'List`1' -Because 'the queue is created with [System.Collections.Generic.List[string]]::new()'
    }

    It 'Queue holds the two servers that are left' {
        @($Queue) -join ', ' | Should -Be 'FS-03, FS-05' -Because 'three servers were added and FS-04 was taken out with Remove'
    }

    It 'StillQueued says that FS-05 is in the queue' {
        ($StillQueued -is [bool]) | Should -BeTrue -Because 'Contains answers with $true or $false'
        $StillQueued | Should -BeTrue
    }

    It 'Waiting is the number of servers left' {
        $Waiting | Should -Be 2 -Because 'Count is the number of elements after adding and removing'
    }
}
