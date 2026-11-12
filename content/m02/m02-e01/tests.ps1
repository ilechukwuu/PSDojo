param($SolutionPath)

Describe 'Disk report for PRN-01' {
    BeforeAll {
        . $SolutionPath | Out-Null
    }

    It 'FreePercent is the number printed by the first line' {
        $FreePercent | Should -Be 15 -Because 'the first line already multiplies by 100, copy the number the console shows'
    }

    It 'ServerName is the text printed by the second line' {
        ([string]$ServerName).Trim() | Should -BeExactly 'prn-01.nordwind.example' -Because 'the line turns the name into lower case and appends the domain'
    }

    It 'PatchDay is the day printed by the third line' {
        ([string]$PatchDay).Trim() | Should -Be 'Saturday' -Because 'the console shows the weekday of 14 March 2026'
    }
}
