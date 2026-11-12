param($SolutionPath)

Describe 'Runtime of the nightly backup' {
    BeforeAll {
        . $SolutionPath
        $ast = [System.Management.Automation.Language.Parser]::ParseFile($SolutionPath, [ref]$null, [ref]$null)
        $divisions = @($ast.FindAll({ param($node) $node -is [System.Management.Automation.Language.BinaryExpressionAst] -and [string]$node.Operator -eq 'Divide' }, $true))
        $assigned = @($ast.FindAll({ param($node) $node -is [System.Management.Automation.Language.AssignmentStatementAst] }, $true) | ForEach-Object { $_.Left.Extent.Text })
    }

    It 'Minutes is unchanged' {
        $Minutes | Should -Be 330 -Because 'the behavior must not change. TotalMinutes is the whole duration, Minutes only the share after the full hours'
    }

    It 'Hours is unchanged' {
        $Hours | Should -Be 5.5 -Because 'the behavior must not change. TotalHours is the whole duration in hours'
    }

    It 'Duration is a time span' {
        ($Duration -is [timespan]) | Should -BeTrue -Because 'end minus start gives a TimeSpan'
    }

    It 'No division and no Ticks variable remain' {
        $divisions.Count | Should -Be 0 -Because 'the Total properties replace converting by hand'
        $assigned | Should -Not -Contain '$Ticks' -Because 'the helper variable is no longer needed'
    }
}
