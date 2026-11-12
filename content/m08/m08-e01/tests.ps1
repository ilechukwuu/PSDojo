param($SolutionPath)

Describe 'Morning check on APP-01' {
    BeforeAll {
        . (Join-Path -Path $PSScriptRoot -ChildPath '../../_shared/Stubs.ps1')
        . (Join-Path -Path $PSScriptRoot -ChildPath '../../_shared/Fixtures.ps1')
        Mock Get-Service { Get-DojoService -Name $Name }
        . $SolutionPath
    }

    It 'Stopped holds the six stopped services' {
        @($Stopped).Count | Should -Be 6 -Because 'the condition is $_.Status -eq ''Stopped'''
        @($Stopped | Where-Object { $_.Status -ne 'Stopped' }).Count | Should -Be 0
    }

    It 'NotDisabled holds every service except the disabled one' {
        @($NotDisabled).Name | Should -Not -Contain 'RemoteRegistry' -Because 'not equal is the operator -ne, and RemoteRegistry is disabled'
        @($NotDisabled).Count | Should -Be 11 -Because 'eleven of the twelve services are not disabled'
    }

    It 'Running holds the six running services' {
        @($Running).Count | Should -Be 6 -Because 'the condition is $_.Status -eq ''Running'''
        @($Running).Name | Should -Contain 'Spooler'
    }
}
