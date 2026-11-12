param($SolutionPath)

Describe 'Lines of the disk warning' {
    BeforeAll {
        . $SolutionPath
        $ast = [System.Management.Automation.Language.Parser]::ParseFile($SolutionPath, [ref]$null, [ref]$null)
        $forLoops = @($ast.FindAll({ param($node) $node -is [System.Management.Automation.Language.ForStatementAst] }, $true))
        $foreachLoops = @($ast.FindAll({ param($node) $node -is [System.Management.Automation.Language.ForEachStatementAst] }, $true))
        $plusEquals = @($ast.FindAll({ param($node) $node -is [System.Management.Automation.Language.AssignmentStatementAst] -and [string]$node.Operator -eq 'PlusEquals' }, $true))
        $indexes = @($ast.FindAll({ param($node) $node -is [System.Management.Automation.Language.IndexExpressionAst] }, $true))
    }

    It 'Warnings holds the same two texts' {
        @($Warnings) -join ' | ' | Should -Be 'FS-02 has only 12 GB free | FS-03 has only 8 GB free' -Because 'the behavior must not change'
    }

    It 'The script uses foreach and no for loop' {
        $foreachLoops.Count | Should -Be 1 -Because 'foreach gives the element directly'
        $forLoops.Count | Should -Be 0 -Because 'the counter is no longer needed'
    }

    It 'No index is used' {
        $indexes.Count | Should -Be 0 -Because 'the loop variable replaces $Disks[$i]'
    }

    It 'No += appends inside the loop' {
        $plusEquals.Count | Should -Be 0 -Because 'the loop collects what the block produces, so the whole loop is assigned to $Warnings'
    }
}
