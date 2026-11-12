param($SolutionPath)

Describe 'Memory report for APP-01' {
    BeforeAll {
        . (Join-Path -Path $PSScriptRoot -ChildPath '../../_shared/Fixtures.ps1')
        Mock Get-Process {
            Get-DojoProcess -Name $Name | Sort-Object -Property Name
        }
        . $SolutionPath
    }

    It 'Top has the calculated property MemoryMB' {
        @($Top)[0].MemoryMB | Should -BeGreaterThan 0 -Because 'the expression must be a script block in curly braces, otherwise it is calculated before any object arrives'
    }

    It 'Top holds the two largest processes, largest first' {
        @($Top).Name -join ', ' | Should -Be 'sqlservr, excel' -Because 'after Select-Object the property WorkingSet64 is gone, the sort has to use MemoryMB'
    }

    It 'NameList is the names as plain text' {
        $NameList | Should -Be 'excel, outlook, rdpclip, spoolsv, sqlservr, winword' -Because '-Property returns objects that turn into @{Name=...}. -ExpandProperty returns the bare names'
    }
}
