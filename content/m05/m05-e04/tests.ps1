param($SolutionPath)

Describe 'Capacity report for TS-03' {
    BeforeAll {
        $script:calls = 0
        Mock Get-Process {
            $script:calls++
            [pscustomobject]@{ Name = 'spoolsv'; Id = 2104; WorkingSet64 = 15728640 }
            [pscustomobject]@{ Name = 'winword'; Id = 6120; WorkingSet64 = 734003200 }
            [pscustomobject]@{ Name = 'excel'; Id = 5544; WorkingSet64 = 1288490188 }
            [pscustomobject]@{ Name = 'rdpclip'; Id = 5120; WorkingSet64 = 9437184 }
        }
        . $SolutionPath
        $callCount = $script:calls
    }

    It 'Largest holds the process with the most memory' {
        @($Largest).Name -join ', ' | Should -Be 'excel' -Because 'the pipeline sorts descending and keeps the first object'
    }

    It 'Get-Process was called only once' {
        $callCount | Should -Be 1 -Because 'both results must come from one snapshot. Tee-Object keeps the full list while the pipeline continues'
    }

    It 'AllProcesses holds the complete list' {
        @($AllProcesses).Count | Should -Be 4 -Because 'Tee-Object -Variable AllProcesses stores every process that passes by'
    }

    It 'Total is the number of processes' {
        $Total | Should -Be 4 -Because 'the second pipeline starts from $AllProcesses and counts with Measure-Object'
    }
}
