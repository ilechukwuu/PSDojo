param($SolutionPath)

Describe 'Service count by status for APP-01' {
    BeforeAll {
        . (Join-Path -Path $PSScriptRoot -ChildPath '../../_shared/Stubs.ps1')
        . (Join-Path -Path $PSScriptRoot -ChildPath '../../_shared/Fixtures.ps1')
        $script:calls = 0
        Mock Get-Service {
            $script:calls++
            Get-DojoService -Name $Name
        }
        . $SolutionPath
        $callCount = $script:calls
    }

    It 'The counts and the summary are unchanged' {
        $RunningCount | Should -Be 6 -Because 'the behavior must not change'
        $StoppedCount | Should -Be 6 -Because 'the behavior must not change'
        $Summary | Should -Be 'Running: 6, Stopped: 6' -Because 'the behavior must not change'
    }

    It 'Groups holds one group per status' {
        (@($Groups).Name | Sort-Object) -join ', ' | Should -Be 'Running, Stopped' -Because 'Group-Object -Property Status forms one group per status'
    }

    It 'Get-Service is called exactly once' {
        $callCount | Should -Be 1 -Because 'both counts can be read from the groups, the server does not have to be asked again'
    }
}
