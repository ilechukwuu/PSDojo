param($SolutionPath)

Describe 'Take a line of the monitoring log apart' {
    BeforeAll {
        . $SolutionPath
        $default = @{ Date = $Date; Level = $Level; Server = $Server; Percent = $Percent }

        $Date = $null
        $Level = $null
        $Server = $null
        $Percent = $null
        . $SolutionPath -LogLine '2026-03-15 03:40:02 WARN Volume E: (data, mirrored) on FS-117 is now 82 percent full'
        $longer = @{ Date = $Date; Level = $Level; Server = $Server; Percent = $Percent }

        $ast = [System.Management.Automation.Language.Parser]::ParseFile($SolutionPath, [ref]$null, [ref]$null)
        $splits = @($ast.FindAll({ param($node) $node -is [System.Management.Automation.Language.InvokeMemberExpressionAst] -and [string]$node.Member -eq 'Split' }, $true))
        $numberIndexes = @($ast.FindAll({ param($node) $node -is [System.Management.Automation.Language.IndexExpressionAst] -and $node.Index -is [System.Management.Automation.Language.ConstantExpressionAst] -and $node.Index.Value -is [int] }, $true))
    }

    It 'The default line gives the same values as before' {
        $default.Date | Should -Be '2026-03-14' -Because 'the behavior must not change'
        $default.Level | Should -Be 'ERROR' -Because 'the behavior must not change'
        $default.Server | Should -Be 'FS-02' -Because 'the behavior must not change'
        $default.Percent | Should -Be 91 -Because 'the behavior must not change'
    }

    It 'A line with more words is read correctly too' {
        $longer.Date | Should -Be '2026-03-15' -Because 'the pattern must also match a line with more words. A pattern that counts words does not match here at all'
        $longer.Level | Should -Be 'WARN' -Because 'the level is the word after the time'
        $longer.Server | Should -Be 'FS-117' -Because 'the server is found by the word on in front of it, not by its position in the line'
        $longer.Percent | Should -Be 82 -Because 'the number is found by the word percent after it, not by its position in the line'
    }

    It 'No Split and no numbered position remain' {
        $splits.Count | Should -Be 0 -Because 'one pattern replaces the splitting'
        $numberIndexes.Count | Should -Be 0 -Because 'named groups replace positions such as [6]'
    }
}
