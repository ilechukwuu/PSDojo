param($SolutionPath)

Describe 'Morning report for PRN-01' {
    BeforeAll {
        . $SolutionPath

        $tokens = $null
        $null = [System.Management.Automation.Language.Parser]::ParseFile($SolutionPath, [ref]$tokens, [ref]$null)
        $comments = @($tokens | Where-Object { $_.Kind -eq 'Comment' })
        $lines = @(Get-Content -LiteralPath $SolutionPath)

        function Get-LineOf {
            param($Pattern)
            for ($index = 0; $index -lt $lines.Count; $index++) {
                if ($lines[$index] -match $Pattern) {
                    return ($index + 1)
                }
            }
            return 0
        }

        function Test-Region {
            param($Name, $FirstPattern, $LastPattern)
            $start = Get-LineOf -Pattern "^\s*#region\s+$Name\s*$"
            $first = Get-LineOf -Pattern $FirstPattern
            $last = Get-LineOf -Pattern $LastPattern
            if ($start -eq 0 -or $start -gt $first) {
                return $false
            }
            for ($index = $last; $index -lt $lines.Count; $index++) {
                if ($lines[$index] -match '^\s*#endregion') {
                    return $true
                }
                if ($lines[$index] -match '^\s*#region') {
                    return $false
                }
            }
            return $false
        }
    }

    It 'The four lines still do their work' {
        $ReportLine | Should -Be 'PRN-01 has 14 print queues' -Because 'the four lines of the note must stay unchanged'
        $Contact | Should -Be 'service.desk@nordwind.example'
    }

    It 'The file starts with a block comment' {
        $first = if ($tokens.Count -gt 0) { $tokens[0].Text } else { '' }
        $first.StartsWith('<#') | Should -BeTrue -Because 'the header is a block comment between <# and #>, not single lines with #'
    }

    It 'The block comment names purpose and author' {
        $header = @($comments | Where-Object { $_.Text.StartsWith('<#') })[0].Text
        $header | Should -Match 'Purpose' -Because 'the header says what the script is for'
        $header | Should -Match 'Author' -Because 'the header says who to ask'
    }

    It 'ServerName and Contact are inside the region Settings' {
        Test-Region -Name 'Settings' -FirstPattern '^\s*\$ServerName\s*=' -LastPattern '^\s*\$Contact\s*=' |
            Should -BeTrue -Because 'the region starts with #region Settings above the two lines and ends with #endregion below them'
    }

    It 'QueueCount and ReportLine are inside the region Report' {
        Test-Region -Name 'Report' -FirstPattern '^\s*\$QueueCount\s*=' -LastPattern '^\s*\$ReportLine\s*=' |
            Should -BeTrue -Because 'the region starts with #region Report above the two lines and ends with #endregion below them'
    }

    It 'A single-line comment stands directly above QueueCount' {
        $line = Get-LineOf -Pattern '^\s*\$QueueCount\s*='
        $above = if ($line -ge 2) { $lines[$line - 2] } else { '' }
        ($above -match '^\s*#' -and $above -notmatch '^\s*#(region|endregion)') |
            Should -BeTrue -Because 'the comment starts with # and sits on the line directly above $QueueCount'
    }
}
