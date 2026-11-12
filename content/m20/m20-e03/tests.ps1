param($SolutionPath)

Describe 'Values from the HR list' {
    BeforeAll {
        . $SolutionPath
    }

    It 'Name has single spaces' {
        $Name | Should -BeExactly 'Keller, Anna' -Because '\s+ matches a run of white space, and it is replaced with one space'
    }

    It 'DisplayName is first name and last name' {
        $DisplayName | Should -BeExactly 'Anna Keller' -Because 'the replacement $2 $1 must be in single quotes. In double quotes PowerShell replaces $1 and $2 itself, with nothing'
    }

    It 'Login is the part in front of the @' {
        $Login | Should -BeExactly 'anna.keller' -Because 'the pattern @.*$ matches everything from the @ to the end, and it is replaced with nothing'
    }

    It 'TicketPrefix and TicketNumber come from the named groups' {
        $TicketPrefix | Should -BeExactly 'INC' -Because 'the group named Prefix captures the letters'
        $TicketNumber | Should -Be 4711 -Because 'the group named Number captures the digits, converted with [int]'
    }
}
