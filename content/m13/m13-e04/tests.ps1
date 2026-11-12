param($SolutionPath)

Describe 'Disk monitoring for the file servers' {
    BeforeAll {
        . $SolutionPath
    }

    It 'AverageFreeGB is the average of the three values' {
        $AverageFreeGB | Should -Be 60 -Because 'without parentheses only the last value is divided by 3'
    }

    It 'IsFull is the result of a comparison' {
        ($IsFull -is [bool]) | Should -BeTrue -Because 'a comparison with -eq returns $true or $false, the sign = assigns a value'
        $IsFull | Should -BeFalse
    }

    It 'UsedPercent was not overwritten' {
        $UsedPercent | Should -Be 82 -Because 'the sign = in that line assigned 100 to $UsedPercent instead of comparing'
    }

    It 'Label is the finished text' {
        $Label | Should -Be '25 GB free on FS-03' -Because 'a number on the left of + makes PowerShell try to turn the text into a number'
    }
}
