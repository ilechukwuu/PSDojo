param($SolutionPath)

Describe 'Values for the change ticket' {
    BeforeAll {
        Mock Get-Process {
            $all = @(
                [pscustomobject]@{ Name = 'spoolsv'; Id = 2104 }
                [pscustomobject]@{ Name = 'lsass'; Id = 712 }
                [pscustomobject]@{ Name = 'backupagent'; Id = 4410 }
                [pscustomobject]@{ Name = 'sqlservr'; Id = 1968 }
            )
            $all | Where-Object { -not $Name -or $Name -contains $_.Name }
        }
        . $SolutionPath
    }

    It 'PatchStart is a date object' {
        $type = if ($null -eq $PatchStart) { 'nothing' } else { $PatchStart.GetType().Name }
        $type | Should -Be 'DateTime' -Because 'Get-Date without -Format returns a date object'
    }

    It 'PatchStart is 14 March 2026 at 22:00:00' {
        $PatchStart.ToString('yyyy-MM-dd HH:mm:ss') | Should -Be '2026-03-14 22:00:00' -Because 'Get-Date takes every part you do not set from the current time'
    }

    It 'TicketStamp is the date of today as text in the format yyyyMMdd' {
        $TicketStamp | Should -Be (Get-Date -Format 'yyyyMMdd') -Because 'the parameter -Format with the value yyyyMMdd returns that text'
    }

    It 'Watched holds exactly the two processes spoolsv and lsass' {
        (@($Watched).Name | Sort-Object) -join ', ' | Should -Be 'lsass, spoolsv' -Because 'the parameter -Name takes both names, separated by a comma'
    }

    It 'Syntax holds the syntax of Stop-Process' {
        ($Syntax | Out-String) | Should -Match 'Stop-Process \[' -Because 'the switch -Syntax makes Get-Command return the call syntax'
    }
}
