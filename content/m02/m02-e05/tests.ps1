param($SolutionPath)

Describe 'Free quota on the share Transfer' {
    BeforeAll {
        . $SolutionPath

        $tokens = $null
        $null = [System.Management.Automation.Language.Parser]::ParseFile($SolutionPath, [ref]$tokens, [ref]$null)
        $lines = @(Get-Content -LiteralPath $SolutionPath | Where-Object { $_.Trim() -ne '' })
    }

    It 'Path still holds the share path' {
        $Path | Should -Be '\\FS-02\Transfer' -Because 'the layout changes, the result does not'
    }

    It 'FreeGB and Line still hold the result' {
        $FreeGB | Should -Be 8.5 -Because 'the layout changes, the result does not'
        $Line | Should -Be '\\FS-02\Transfer has 8.5 GB left' -Because 'the layout changes, the result does not'
    }

    It 'No semicolon is left' {
        @($tokens | Where-Object { $_.Kind -eq 'Semi' }).Count | Should -Be 0 -Because 'every statement gets its own line'
    }

    It 'Every line starts in the first column' {
        @($lines | Where-Object { $_ -match '^\s' }).Count | Should -Be 0 -Because 'top-level lines are not indented, and tabs do not belong in a script'
    }

    It 'Every assignment has spaces around the equals sign' {
        @($lines | Where-Object { $_ -match '^\$\w+' -and $_ -notmatch '^\$\w+ = \S' }).Count |
            Should -Be 0 -Because 'one space stands on each side of the equals sign'
    }

    It 'The calculation has spaces around the minus sign' {
        @($lines | Where-Object { $_ -match '^\$FreeGB' })[0] | Should -Match '\$LimitGB - \$UsedGB' -Because 'one space stands on each side of an operator'
    }
}
