param($SolutionPath)

Describe 'Texts for the weekly disk report' {
    BeforeAll {
        . $SolutionPath
        $ast = [System.Management.Automation.Language.Parser]::ParseFile($SolutionPath, [ref]$null, [ref]$null)
        $plus = @($ast.FindAll({ param($node) $node -is [System.Management.Automation.Language.BinaryExpressionAst] -and [string]$node.Operator -eq 'Plus' }, $true))
    }

    It 'Line is unchanged' {
        $Line | Should -BeExactly 'Server FS-02 drive D: has 75 GB free (15 percent)' -Because 'the behavior must not change'
    }

    It 'Path is unchanged' {
        $Path | Should -BeExactly 'reports/FS-02_week11.csv' -Because 'the behavior must not change. An underscore after a variable name needs ${ } around the name'
    }

    It 'No plus sign joins texts any more' {
        $plus.Count | Should -Be 0 -Because 'one text with inserted values replaces the chain of pieces'
    }
}
