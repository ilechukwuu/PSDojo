param($SolutionPath)

Describe 'Texts for the capacity report' {
    BeforeAll {
        . $SolutionPath
        $code = (Get-Content -LiteralPath $SolutionPath | Where-Object { $_ -notmatch '^\s*#' }) -join "`n"
    }

    It 'The three texts are unchanged' {
        $Title | Should -Be 'Capacity report for FS-02' -Because 'the behavior must not change'
        $Note | Should -Be 'Warning above 90 percent on FS-02' -Because 'the behavior must not change'
        $Footer | Should -Be 'FS-02 is checked daily, limit 90' -Because 'the behavior must not change'
    }

    It 'Server and WarnAtPercent are defined' {
        $Server | Should -Be 'FS-02' -Because 'the server name is stored once in $Server'
        $WarnAtPercent | Should -Be 90 -Because 'the threshold is stored once in $WarnAtPercent'
    }

    It 'The server name is typed only once' {
        ([regex]::Matches($code, 'FS-02')).Count | Should -Be 1 -Because 'every other place uses the variable $Server'
    }

    It 'The threshold is typed only once' {
        ([regex]::Matches($code, '\b90\b')).Count | Should -Be 1 -Because 'every other place uses the variable $WarnAtPercent'
    }
}
