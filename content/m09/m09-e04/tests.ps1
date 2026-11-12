param($SolutionPath)

Describe 'Capacity report for APP-01' {
    BeforeAll {
        . (Join-Path -Path $PSScriptRoot -ChildPath '../../_shared/Fixtures.ps1')
        Mock Get-Process { Get-DojoProcess -Name $Name | Sort-Object -Property Name }
        . $SolutionPath
    }

    It 'Report holds one object per process with three properties' {
        @($Report).Count | Should -Be 6 -Because 'there is one object per process'
        @($Report)[0].PSObject.Properties.Name -join ', ' | Should -Be 'Name, MemoryMB, Team' -Because 'Select-Object builds objects with exactly the properties in the list'
    }

    It 'MemoryMB is the working set in megabytes' {
        (@($Report) | Where-Object { $_.Name -eq 'excel' }).MemoryMB | Should -Be 1200 -Because 'the expression divides WorkingSet64 by 1MB and rounds'
    }

    It 'Team is the category under a new name' {
        (@($Report) | Where-Object { $_.Name -eq 'sqlservr' }).Team | Should -Be 'Database' -Because 'the expression returns the property Category'
    }

    It 'Sorted is ordered by MemoryMB, largest first' {
        @($Sorted).Name -join ', ' | Should -Be 'sqlservr, excel, winword, outlook, spoolsv, rdpclip' -Because 'the new objects only have MemoryMB, the property WorkingSet64 no longer exists on them'
    }
}
