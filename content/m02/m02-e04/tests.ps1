param($SolutionPath)

Describe 'Free space check for the file servers' {
    BeforeAll {
        . $SolutionPath
    }

    It 'TotalAfterSecondPass is the running total after two servers' {
        $TotalAfterSecondPass | Should -Be 155 -Because 'the total keeps what it had and adds the next server, it does not start again'
    }

    It 'LowServer is the server with less than 10 GB' {
        ([string]$LowServer).Trim() | Should -Be 'FS-03' -Because 'only one server has less than 10 GB free'
    }

    It 'FinalTotal is the sum of all four servers' {
        $FinalTotal | Should -Be 227 -Because 'the loop adds all four values'
    }
}
