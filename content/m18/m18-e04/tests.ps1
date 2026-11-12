param($SolutionPath)

Describe 'Rating of a server before patching' {
    BeforeAll {
        . $SolutionPath -Status 'Running' -FreePercent 5 -Server 'FS-02'
        $runningStart = $ShouldStart
        $runningStatus = $Status
        $priorityFive = $Priority
        $roleFile = @($Role)

        . $SolutionPath -Status 'Stopped' -FreePercent 15 -Server 'PRN-01'
        $stoppedStart = $ShouldStart
        $priorityFifteen = $Priority
        $roleOther = @($Role)

        . $SolutionPath -Status 'Running' -FreePercent 60 -Server 'FS-01'
        $prioritySixty = $Priority
    }

    It 'ShouldStart is false for a running service' {
        $runningStart | Should -BeFalse -Because 'the condition must compare with -eq. A single = assigns the text, and a non-empty text is always true'
    }

    It 'Status keeps its value' {
        $runningStatus | Should -Be 'Running' -Because 'a single = in the condition overwrites the variable'
    }

    It 'ShouldStart is true for a stopped service' {
        $stoppedStart | Should -BeTrue -Because 'a stopped service should be started'
    }

    It 'Priority is High below 10 percent' {
        $priorityFive | Should -Be 'High' -Because 'only the first matching block runs, so below 10 must be checked before below 20'
    }

    It 'Priority is Medium below 20 and Low otherwise' {
        $priorityFifteen | Should -Be 'Medium'
        $prioritySixty | Should -Be 'Low'
    }

    It 'Role is exactly one text' {
        $roleFile -join ' + ' | Should -Be 'File server' -Because 'a switch checks every case, and the case * matches every name as well. default only runs when nothing else matched'
        $roleOther -join ' + ' | Should -Be 'Other'
    }
}
