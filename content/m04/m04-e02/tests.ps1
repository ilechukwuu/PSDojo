param($SolutionPath)

Describe 'Environment variables through Env:' {
    BeforeAll {
        Remove-Item -Path Env:DOJO_TICKET -ErrorAction SilentlyContinue
        . $SolutionPath
    }

    AfterAll {
        Remove-Item -Path Env:DOJO_TICKET, Env:DOJO_SITE -ErrorAction SilentlyContinue
    }

    It 'AllVariables holds the environment variables' {
        @($AllVariables).Name | Should -Contain 'DOJO_SITE' -Because 'Get-ChildItem -Path Env: lists every environment variable'
    }

    It 'Site holds only the value' {
        $type = if ($null -eq $Site) { 'nothing' } else { $Site.GetType().Name }
        $type | Should -Be 'String' -Because 'Get-Item returns the whole item, the text is in its property Value'
        $Site | Should -Be 'Hamburg'
    }

    It 'DOJO_TICKET was created with its value' {
        $env:DOJO_TICKET | Should -Be 'INC-4711' -Because 'New-Item creates the variable with -Path Env:DOJO_TICKET and -Value'
    }

    It 'TicketExists is the answer of Test-Path' {
        ($TicketExists -is [bool]) | Should -BeTrue -Because 'Test-Path answers with $true or $false'
        $TicketExists | Should -BeTrue
    }
}
