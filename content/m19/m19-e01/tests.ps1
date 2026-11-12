param($SolutionPath)

Describe 'One report row per volume' {
    BeforeAll {
        . $SolutionPath | Out-Null
    }

    It 'Report holds one row per volume' {
        @($Report).Count | Should -Be 3 -Because 'the whole foreach is assigned to $Report, so it collects one object per pass. Assigning inside the block keeps only the last one'
    }

    It 'Each row has the three properties in order' {
        @($Report)[0].PSObject.Properties.Name -join ', ' | Should -Be 'Server, FreePercent, State' -Because 'the object is built with [pscustomobject] in this order'
    }

    It 'FreePercent is calculated per volume' {
        @($Report).FreePercent -join ', ' | Should -Be '42, 8, 18' -Because 'free divided by size times 100, rounded, for each volume'
    }

    It 'State is Low below 20 percent' {
        @($Report).State -join ', ' | Should -Be 'OK, Low, Low' -Because '8 and 18 percent are below 20'
    }
}
