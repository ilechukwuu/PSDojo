param($SolutionPath)

Describe 'Facts about the processes on TS-03' {
    BeforeAll {
        Mock Get-Process {
            [pscustomobject]@{ Name = 'spoolsv'; Id = 2104; WorkingSet64 = 15728640 }
            [pscustomobject]@{ Name = 'winword'; Id = 6120; WorkingSet64 = 734003200 }
            [pscustomobject]@{ Name = 'excel'; Id = 5544; WorkingSet64 = 1288490188 }
            [pscustomobject]@{ Name = 'rdpclip'; Id = 5120; WorkingSet64 = 9437184 }
            [pscustomobject]@{ Name = 'outlook'; Id = 4980; WorkingSet64 = 524288000 }
        }
        . $SolutionPath
    }

    It 'ByName holds all processes sorted by name' {
        @($ByName).Name -join ', ' | Should -Be 'excel, outlook, rdpclip, spoolsv, winword' -Because 'Sort-Object -Property Name sorts what Get-Process sends through the pipe'
    }

    It 'TopTwo holds the two processes with the most memory' {
        @($TopTwo).Name -join ', ' | Should -Be 'excel, winword' -Because 'the list must be sorted before Select-Object takes the first two'
    }

    It 'ProcessCount is the number of processes' {
        $ProcessCount | Should -Be 5 -Because 'Measure-Object counts the objects, the number is in its property Count'
    }
}
