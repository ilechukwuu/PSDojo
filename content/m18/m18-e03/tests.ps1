param($SolutionPath)

Describe 'Recommended action and server role' {
    BeforeAll {
        $actions = @{}
        foreach ($status in 'Running', 'Stopped', 'Paused', 'StartPending') {
            . $SolutionPath -Status $status -Server 'FS-02'
            $actions[$status] = $Action
        }
        $roles = @{}
        foreach ($server in 'FS-02', 'PRN-01', 'APP-012', 'DC-01') {
            . $SolutionPath -Status 'Running' -Server $server
            $roles[$server] = $Role
        }
    }

    It 'Action follows the status' {
        $actions['Running'] | Should -Be 'Nothing to do' -Because 'the case Running returns this text'
        $actions['Stopped'] | Should -Be 'Start the service'
        $actions['Paused'] | Should -Be 'Resume the service'
    }

    It 'An unknown status gets the default action' {
        $actions['StartPending'] | Should -Be 'Check by hand' -Because 'default catches every value that no case matched'
    }

    It 'Role follows the start of the server name' {
        $roles['FS-02'] | Should -Be 'File server' -Because 'a case with a star only works with switch -Wildcard'
        $roles['PRN-01'] | Should -Be 'Print server'
        $roles['APP-012'] | Should -Be 'Application server'
    }

    It 'An unknown name gets the default role' {
        $roles['DC-01'] | Should -Be 'Unknown' -Because 'default catches every name that no case matched'
    }
}
