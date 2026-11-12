param($SolutionPath)

Describe 'Memory monitoring for TS-03' {
    BeforeAll {
        Mock Get-Process {
            [pscustomobject]@{ Name = 'spoolsv'; Id = 2104; WorkingSet64 = 15728640 }
            [pscustomobject]@{ Name = 'winword'; Id = 6120; WorkingSet64 = 734003200 }
            [pscustomobject]@{ Name = 'excel'; Id = 5544; WorkingSet64 = 1288490188 }
            [pscustomobject]@{ Name = 'rdpclip'; Id = 5120; WorkingSet64 = 9437184 }
        }
        . $SolutionPath
        $leadingPipes = @(Get-Content -LiteralPath $SolutionPath | Where-Object { $_ -match '^\s*\|' })
    }

    It 'Sorted holds all processes sorted by name' {
        @($Sorted).Name -join ', ' | Should -Be 'excel, rdpclip, spoolsv, winword' -Because 'a semicolon separates two commands, only the pipe hands the processes to Sort-Object'
    }

    It 'TopTwo holds the two largest processes' {
        @($TopTwo).Name -join ', ' | Should -Be 'excel, winword' -Because 'sorting must come before Select-Object -First 2'
    }

    It 'Smallest holds the process with the least memory' {
        @($Smallest).Name -join ', ' | Should -Be 'rdpclip' -Because 'the three lines must form one pipeline'
    }

    It 'No line starts with a pipe character' {
        $leadingPipes.Count | Should -Be 0 -Because 'Windows PowerShell 5.1 cannot read a line that starts with a pipe. The pipe goes at the end of the line above'
    }
}
