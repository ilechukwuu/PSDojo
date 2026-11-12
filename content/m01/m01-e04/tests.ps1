param($SolutionPath)

Describe 'Morning check for TS-03' {
    BeforeAll {
        Mock Get-Process {
            $all = @(
                [pscustomobject]@{ Name = 'spoolsv'; Id = 2104 }
                [pscustomobject]@{ Name = 'rdpclip'; Id = 5120 }
                [pscustomobject]@{ Name = 'lsass'; Id = 712 }
            )
            $all | Where-Object { -not $Name -or $Name -contains $_.Name }
        }
        . $SolutionPath
    }

    It 'Spooler holds the spoolsv process' {
        @($Spooler).Name | Should -Be 'spoolsv' -Because 'line 1 asks Get-Process for the process named spoolsv'
    }

    It 'ProcessCommands holds the commands with the noun Process' {
        @($ProcessCommands).Name | Should -Contain 'Get-Process' -Because 'a parameter name needs a hyphen in front, otherwise it is read as a value'
    }

    It 'Stamp holds the date of today as text' {
        $Stamp | Should -Be (Get-Date -Format 'yyyy-MM-dd') -Because 'the parameter -Format turns the date into text'
    }
}
