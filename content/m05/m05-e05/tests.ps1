param($SolutionPath)

Describe 'The three largest processes on TS-03' {
    BeforeAll {
        Mock Get-Process {
            [pscustomobject]@{ Name = 'spoolsv'; Id = 2104; WorkingSet64 = 15728640 }
            [pscustomobject]@{ Name = 'winword'; Id = 6120; WorkingSet64 = 734003200 }
            [pscustomobject]@{ Name = 'excel'; Id = 5544; WorkingSet64 = 1288490188 }
            [pscustomobject]@{ Name = 'rdpclip'; Id = 5120; WorkingSet64 = 9437184 }
            [pscustomobject]@{ Name = 'outlook'; Id = 4980; WorkingSet64 = 524288000 }
        }
        . $SolutionPath

        $ast = [System.Management.Automation.Language.Parser]::ParseFile($SolutionPath, [ref]$null, [ref]$null)
        $assigned = @($ast.FindAll({ param($node) $node -is [System.Management.Automation.Language.AssignmentStatementAst] }, $true) |
                ForEach-Object { $_.Left.Extent.Text })
    }

    It 'Report still holds the three largest processes' {
        @($Report).Name -join ', ' | Should -Be 'excel, winword, outlook' -Because 'the behavior must not change'
    }

    It 'ReportCount still holds the number' {
        $ReportCount | Should -Be 3 -Because 'the behavior must not change'
    }

    It 'Only Report and ReportCount are assigned' {
        ($assigned | Where-Object { '$Report', '$ReportCount' -notcontains $_ }) -join ', ' |
            Should -Be '' -Because 'a pipeline replaces variables that only carry a result to the next line'
    }
}
