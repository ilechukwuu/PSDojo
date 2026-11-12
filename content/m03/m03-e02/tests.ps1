param($SolutionPath)

Describe 'Runbook notes on syntax' {
    BeforeAll {
        . $SolutionPath
    }

    It 'RequiredParameter is the parameter that always needs a value' {
        ([string]$RequiredParameter).Trim().TrimStart('-') | Should -Be 'Name' -Because 'only the name is in brackets, so the name is optional but the value is required'
    }

    It 'SwitchCount is the number of switches of Restart-Service' {
        $SwitchCount | Should -Be 4 -Because 'every parameter without a type after its name is a switch, and that includes -WhatIf and -Confirm'
    }

    It 'ListParameter is the parameter of Get-EventLog that accepts several values' {
        ([string]$ListParameter).Trim().TrimStart('-') | Should -Be 'EntryType' -Because 'several values are allowed where the type ends with []'
    }

    It 'CallIsValid says whether the positional call works' {
        $CallIsValid | Should -BeTrue -Because 'the name -LogName is in brackets, so the value System is taken by position'
        ($CallIsValid -is [bool]) | Should -BeTrue -Because 'the answer is $true or $false, not text'
    }
}
