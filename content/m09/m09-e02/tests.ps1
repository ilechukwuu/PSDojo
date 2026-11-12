param($SolutionPath)

Describe 'Numbers about APP-01' {
    BeforeAll {
        . (Join-Path -Path $PSScriptRoot -ChildPath '../../_shared/Stubs.ps1')
        . (Join-Path -Path $PSScriptRoot -ChildPath '../../_shared/Fixtures.ps1')
        Mock Get-Service { Get-DojoService -Name $Name }
        Mock Get-Process { Get-DojoProcess -Name $Name }
        . $SolutionPath
    }

    It 'ByStartType holds one group per start type' {
        (@($ByStartType).Name | Sort-Object) -join ', ' | Should -Be 'Automatic, Disabled, Manual' -Because 'Group-Object -Property StartType forms one group per value'
        (@($ByStartType) | Where-Object { $_.Name -eq 'Automatic' }).Count | Should -Be 8
    }

    It 'Memory holds sum, average and maximum' {
        $Memory.Sum | Should -Be (4472 * 1MB) -Because 'Measure-Object only fills Sum when the switch -Sum is given'
        $Memory.Maximum | Should -Be (2048 * 1MB) -Because 'Measure-Object only fills Maximum when the switch -Maximum is given'
        $Memory.Average | Should -Not -BeNullOrEmpty -Because 'Measure-Object only fills Average when the switch -Average is given'
    }

    It 'TotalMB is the sum in megabytes' {
        $TotalMB | Should -Be 4472 -Because 'the sum in bytes divided by 1MB gives megabytes'
    }
}
