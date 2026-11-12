param($SolutionPath)

Describe 'Patch plan for the file servers' {
    BeforeAll {
        . $SolutionPath
    }

    It 'Servers is the list of five servers in order' {
        @($Servers) -join ', ' | Should -Be 'FS-01, FS-02, FS-03, FS-04, FS-05' -Because 'the values are separated by commas'
    }

    It 'Pilot is the first server' {
        $Pilot | Should -Be 'FS-01' -Because 'counting starts at 0, so the first element is [0]'
    }

    It 'Final is the last server' {
        $Final | Should -Be 'FS-05' -Because '[-1] is the last element'
    }

    It 'WaveTwo is the second and third server' {
        @($WaveTwo) -join ', ' | Should -Be 'FS-02, FS-03' -Because 'the second and third element are at positions 1 and 2'
    }

    It 'Total is the number of servers' {
        $Total | Should -Be 5 -Because 'Count is the number of elements'
    }
}
