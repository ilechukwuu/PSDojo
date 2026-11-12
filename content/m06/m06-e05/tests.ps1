param($SolutionPath)

Describe 'Calculated values for the usage report' {
    BeforeAll {
        . $SolutionPath
    }

    It 'RoundedC is rounded to one decimal place' {
        $RoundedC | Should -Be 81.4 -Because 'Round needs a second argument for the number of decimal places, otherwise it rounds to a whole number'
    }

    It 'Highest is the larger of the two values' {
        $Highest | Should -Be 93.8215 -Because '[math]::Max returns the larger of its two arguments'
    }

    It 'Extension is the ending of the file name' {
        $Extension | Should -Be '.csv' -Because '[System.IO.Path]::GetExtension returns the ending with the dot'
    }

    It 'Today is the date of today at midnight' {
        $type = if ($null -eq $Today) { 'nothing' } else { $Today.GetType().Name }
        $type | Should -Be 'DateTime' -Because '[datetime]::Today is a date object'
        $Today | Should -Be ([datetime]::Today) -Because 'Today has the time 00:00:00, unlike Now'
    }
}
