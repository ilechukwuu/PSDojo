param($SolutionPath)

Describe 'Patch script for the file servers' {
    BeforeAll {
        . $SolutionPath
    }

    It 'FirstFailed is the whole server name' {
        $FirstFailed | Should -BeExactly 'FS-03' -Because 'a single text is not an array. With @( ) around it, [0] returns the first element instead of the first letter'
    }

    It 'Servers holds five servers' {
        @($Servers) -join ', ' | Should -Be 'FS-01, FS-02, FS-03, FS-04, FS-05' -Because 'an array has a fixed size and no working Add, an element is appended with +='
    }

    It 'LastServer is the last element' {
        $LastServer | Should -BeExactly 'FS-05' -Because 'positions start at 0, so the position Count does not exist. The last element is [-1]'
    }
}
