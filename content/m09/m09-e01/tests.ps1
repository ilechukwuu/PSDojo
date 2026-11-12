param($SolutionPath)

Describe 'Weekly service report for APP-01' {
    BeforeAll {
        . (Join-Path -Path $PSScriptRoot -ChildPath '../../_shared/Stubs.ps1')
        . (Join-Path -Path $PSScriptRoot -ChildPath '../../_shared/Fixtures.ps1')
        Mock Get-Service { Get-DojoService -Name $Name }
        . $SolutionPath
    }

    It 'Sorted is ordered by status and then by name' {
        (@($Sorted) | Select-Object -First 3).Name -join ', ' | Should -Be 'LanmanServer, MSSQLSERVER, NordwindApi' -Because 'Running comes before Stopped, and within Running the names are sorted'
        @($Sorted)[-1].Name | Should -Be 'W32Time'
    }

    It 'Narrow holds objects with exactly two properties' {
        @($Narrow).Count | Should -Be 12 -Because 'there is one object per service'
        @($Narrow)[0].PSObject.Properties.Name -join ', ' | Should -Be 'Name, StartType' -Because 'Select-Object -Property keeps only the properties you name'
    }

    It 'StartTypes holds each start type once as text' {
        $type = if ($null -eq $StartTypes) { 'nothing' } else { @($StartTypes)[0].GetType().Name }
        $type | Should -Be 'String' -Because '-ExpandProperty returns the bare values, -Property returns objects'
        @($StartTypes) -join ', ' | Should -Be 'Automatic, Disabled, Manual'
    }
}
