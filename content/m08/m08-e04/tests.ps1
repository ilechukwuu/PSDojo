param($SolutionPath)

Describe 'Service monitoring for APP-01' {
    BeforeAll {
        . (Join-Path -Path $PSScriptRoot -ChildPath '../../_shared/Stubs.ps1')
        . (Join-Path -Path $PSScriptRoot -ChildPath '../../_shared/Fixtures.ps1')
        Mock Get-Service { Get-DojoService -Name $Name }
        . $SolutionPath 2>$null
    }

    It 'Stopped holds the six stopped services' {
        @($Stopped).Count | Should -Be 6 -Because 'a filter compares with -eq. The sign = assigns a value and lets nothing through'
    }

    It 'Nordwind holds the three Nordwind services' {
        (@($Nordwind).Name | Sort-Object) -join ', ' | Should -Be 'NordwindApi, NordwindPrint, NordwindSync' -Because 'a wildcard is only understood by -like, with -eq the star is an ordinary character'
    }

    It 'Running holds the six running services' {
        @($Running).Count | Should -Be 6 -Because 'a property inside the braces needs $_ and a dot in front'
    }
}
