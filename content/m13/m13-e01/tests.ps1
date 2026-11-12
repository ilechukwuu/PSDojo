param($SolutionPath)

Describe 'Values for the archive job on FS-02' {
    BeforeAll {
        . $SolutionPath
    }

    It 'TotalGB is the sum of both volumes in gigabytes' {
        $TotalGB | Should -Be 500 -Because 'division is done before addition, so the sum needs parentheses before it is divided by 1GB'
    }

    It 'FreePercent is the free share as a whole number' {
        $FreePercent | Should -Be 15 -Because '75 GB free of 500 GB is 15 percent'
    }

    It 'LeftOver is the remainder after full batches' {
        $LeftOver | Should -Be 47 -Because '1047 files in batches of 50 leave a remainder, and % returns it'
    }

    It 'Processed was increased by the batch size and by one' {
        $Processed | Should -Be 171 -Because '120 plus 50 with += and one more with ++ is 171'
    }
}
