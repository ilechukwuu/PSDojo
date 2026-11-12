param($SolutionPath)

Describe 'Process check for TS-03' {
    BeforeAll {
        $script:calls = 0
        Mock Get-Process {
            $script:calls++
            $all = @(
                [pscustomobject]@{ Name = 'spoolsv'; Id = 2104 }
                [pscustomobject]@{ Name = 'lsass'; Id = 712 }
                [pscustomobject]@{ Name = 'rdpclip'; Id = 5120 }
                [pscustomobject]@{ Name = 'backupagent'; Id = 4410 }
                [pscustomobject]@{ Name = 'winword'; Id = 6120 }
            )
            $all | Where-Object { -not $Name -or $Name -contains $_.Name }
        }
        . $SolutionPath
        $callCount = $script:calls

        $ast = [System.Management.Automation.Language.Parser]::ParseFile($SolutionPath, [ref]$null, [ref]$null)
        $assigned = @($ast.FindAll({ param($node) $node -is [System.Management.Automation.Language.AssignmentStatementAst] }, $true) |
                ForEach-Object { $_.Left.Extent.Text })
    }

    It 'Found still holds the four processes' {
        (@($Found).Name | Sort-Object) -join ', ' | Should -Be 'backupagent, lsass, rdpclip, spoolsv' -Because 'the behavior must not change'
    }

    It 'Get-Process is called exactly once' {
        $callCount | Should -Be 1 -Because 'the parameter -Name takes the whole list, so one call is enough'
    }

    It 'Only Names and Found are assigned' {
        ($assigned | Where-Object { '$Names', '$Found' -notcontains $_ }) -join ', ' | Should -Be '' -Because 'the helper variables are no longer needed'
    }
}
