param($SolutionPath)

Describe 'Capacity script for FS-02' {
    BeforeAll {
        . $SolutionPath
    }

    It 'TotalGB is the sum as a number' {
        $TotalGB | Should -Be 120 -Because 'both values are text and must be converted with [int] before adding, otherwise they are joined'
    }

    It 'DriveCount is the number 12' {
        $DriveCount | Should -Be 12 -Because 'a variable typed as [int] needs a value that can become a number'
    }

    It 'Line names the server' {
        $Line | Should -Be 'Server: FS-02' -Because 'a mistyped variable name is an empty variable, PowerShell does not report it'
    }
}
