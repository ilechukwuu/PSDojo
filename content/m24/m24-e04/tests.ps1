param($SolutionPath)

Describe 'A status for every volume' {
    BeforeAll {
        $testVolumes = @(
            [pscustomobject]@{ Name = 'D:'; FreePercent = 40 }
            [pscustomobject]@{ Name = 'E:'; FreePercent = 15 }
            [pscustomobject]@{ Name = 'F:'; FreePercent = 4 }
        )
        . $SolutionPath -Volumes $testVolumes 2>$null
    }

    It 'Statuses holds one status per volume' {
        @($Statuses) -join ', ' | Should -Be 'ok, warning, critical' -Because 'a block invoked with & has no $_. It has to take the volume through param, otherwise every comparison works on an empty value'
    }

    It 'Critical holds the volume below 10 percent' {
        @($Critical).Name -join ', ' | Should -Be 'F:' -Because 'the filter of Where-Object has to be a script block in braces'
    }
}
