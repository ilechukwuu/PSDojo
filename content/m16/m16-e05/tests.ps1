param($SolutionPath)

Describe 'Announcement for the patch night' {
    BeforeAll {
        . $SolutionPath
        $lineThree = $Line
        $lastThree = @($LastTwo) -join ', '
        $summaryThree = $Summary

        . $SolutionPath -Servers @('FS-01', 'FS-02', 'FS-03', 'FS-04', 'FS-05')
        $lineFive = $Line
        $lastFive = @($LastTwo) -join ', '
        $summaryFive = $Summary

        $ast = [System.Management.Automation.Language.Parser]::ParseFile($SolutionPath, [ref]$null, [ref]$null)
        $plus = @($ast.FindAll({ param($node) $node -is [System.Management.Automation.Language.BinaryExpressionAst] -and [string]$node.Operator -eq 'Plus' }, $true))
    }

    It 'The texts are unchanged for three servers' {
        $lineThree | Should -Be 'FS-01, FS-02, FS-03' -Because 'the behavior must not change'
        $lastThree | Should -Be 'FS-02, FS-03' -Because 'the behavior must not change'
        $summaryThree | Should -Be '3 servers: FS-01, FS-02, FS-03' -Because 'the behavior must not change'
    }

    It 'Line names all five servers' {
        $lineFive | Should -Be 'FS-01, FS-02, FS-03, FS-04, FS-05' -Because '-join connects every element, however many there are'
    }

    It 'LastTwo is the last two of five servers' {
        $lastFive | Should -Be 'FS-04, FS-05' -Because 'negative positions count from the end, fixed positions point at the wrong servers once the list grows'
    }

    It 'Summary counts the servers itself' {
        $summaryFive | Should -Be '5 servers: FS-01, FS-02, FS-03, FS-04, FS-05' -Because 'the number comes from Count, not from a typed 3'
    }

    It 'No plus sign glues elements together' {
        $plus.Count | Should -Be 0 -Because '-join and an inserted value replace the chain of pieces'
    }
}
