param($SolutionPath)

Describe 'Three lists for the on-call engineer' {
    BeforeAll {
        . (Join-Path -Path $PSScriptRoot -ChildPath '../../_shared/Stubs.ps1')
        . (Join-Path -Path $PSScriptRoot -ChildPath '../../_shared/Fixtures.ps1')
        Mock Get-Service { Get-DojoService -Name $Name }
        . $SolutionPath
    }

    It 'Broken holds the stopped services that start automatically' {
        (@($Broken).Name | Sort-Object) -join ', ' | Should -Be 'NordwindPrint, NordwindSync, SQLSERVERAGENT' -Because 'both conditions must be true at once, that is -and'
    }

    It 'Nordwind holds the services whose name starts with Nordwind' {
        (@($Nordwind).Name | Sort-Object) -join ', ' | Should -Be 'NordwindApi, NordwindPrint, NordwindSync' -Because '-like with the wildcard * matches every name that starts with Nordwind'
    }

    It 'CriticalDown holds the critical services that are not running' {
        (@($CriticalDown).Name | Sort-Object) -join ', ' | Should -Be 'NordwindSync, SQLSERVERAGENT' -Because 'the name must be in the list and the status must not be Running'
    }
}
