param($SolutionPath)

Describe 'Exit code of the backup tool as text' {
    BeforeAll {
        $texts = @{}
        foreach ($code in 0, 1, 2, 5, 9) {
            . $SolutionPath -ExitCode $code
            $texts[$code] = $Text
        }
        $ast = [System.Management.Automation.Language.Parser]::ParseFile($SolutionPath, [ref]$null, [ref]$null)
        $ifs = @($ast.FindAll({ param($node) $node -is [System.Management.Automation.Language.IfStatementAst] }, $true))
        $switches = @($ast.FindAll({ param($node) $node -is [System.Management.Automation.Language.SwitchStatementAst] }, $true))
    }

    It 'The known exit codes give the same texts as before' {
        $texts[0] | Should -Be 'Backup finished' -Because 'the behavior must not change'
        $texts[1] | Should -Be 'Finished with warnings' -Because 'the behavior must not change'
        $texts[2] | Should -Be 'Target not reachable' -Because 'the behavior must not change'
        $texts[5] | Should -Be 'Access denied' -Because 'the behavior must not change'
    }

    It 'An unknown exit code still gets its text' {
        $texts[9] | Should -Be 'Unknown exit code' -Because 'the else block of the chain becomes the default case of the switch'
    }

    It 'The file uses one switch and no if' {
        $switches.Count | Should -Be 1 -Because 'one switch replaces the whole chain'
        $ifs.Count | Should -Be 0 -Because 'no if is needed any more'
    }
}
