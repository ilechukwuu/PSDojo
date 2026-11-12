param($SolutionPath)

Describe 'Patch report' {
    BeforeAll {
        . $SolutionPath
    }

    It 'Checks names one server per line' {
        @($Checks) -join ' | ' | Should -Be 'Checking FS-01 | Checking FS-02 | Checking FS-03 | Checking FS-04' -Because 'inside the loop the element is $Server. $Servers with an s is the whole list'
    }

    It 'Numbered holds exactly four lines' {
        @($Numbered).Count | Should -Be 4 -Because 'positions start at 0, so the loop must run while $i is less than Count, not less or equal'
        @($Numbered)[3] | Should -Be '4: FS-04'
    }

    It 'ToPatch holds every server except the excluded one' {
        @($ToPatch) -join ', ' | Should -Be 'FS-01, FS-03, FS-04' -Because 'continue skips one element and goes on. break ends the whole loop and drops everything after it'
    }
}
