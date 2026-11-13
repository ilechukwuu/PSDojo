param($SolutionPath)

Describe 'The execution policy that really applies' {
    BeforeAll {
        function New-PolicyList {
            param([string[]]$Values)
            $scopes = 'MachinePolicy', 'UserPolicy', 'Process', 'CurrentUser', 'LocalMachine'
            for ($i = 0; $i -lt 5; $i++) {
                [pscustomobject]@{ Scope = $scopes[$i]; ExecutionPolicy = $Values[$i] }
            }
        }
        $script:policyData = @(New-PolicyList -Values 'Undefined', 'Undefined', 'Undefined', 'RemoteSigned', 'AllSigned')
        Mock Get-ExecutionPolicy { $script:policyData }

        . $SolutionPath
        $userPolicies = $Policies
        $userEffective = $Effective
        $userSetBy = $SetBy

        $script:policyData = @(New-PolicyList -Values 'AllSigned', 'Undefined', 'Bypass', 'RemoteSigned', 'RemoteSigned')
        $Effective = $null
        $SetBy = $null
        . $SolutionPath
    }

    It 'Policies holds the five scopes' {
        @($userPolicies).Count | Should -Be 5 -Because 'Get-ExecutionPolicy -List returns one entry per scope'
        Should -Invoke Get-ExecutionPolicy -Scope Describe -ParameterFilter { $List } -Because 'only the switch -List shows all scopes'
    }

    It 'The first defined scope wins' {
        $userEffective | Should -Be 'RemoteSigned' -Because 'the first entry from the top that is not Undefined applies. Here that is CurrentUser, which comes before LocalMachine'
        $userSetBy | Should -Be 'CurrentUser'
    }

    It 'A Group Policy setting beats everything else' {
        $Effective | Should -Be 'AllSigned' -Because 'MachinePolicy stands at the top of the list and is defined here'
        $SetBy | Should -Be 'MachinePolicy'
    }

    It 'Effective and SetBy are text' {
        ($Effective -is [string] -and $SetBy -is [string]) | Should -BeTrue -Because 'the task asks for both values as text, so convert with [string]'
    }
}
