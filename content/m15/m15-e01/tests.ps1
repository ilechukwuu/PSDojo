param($SolutionPath)

Describe 'Stale account check for one account' {
    BeforeAll {
        . $SolutionPath
    }

    It 'Limit is 90 days before today' {
        ([datetime]$Limit).ToString('yyyy-MM-dd') | Should -Be '2025-12-14' -Because 'a date in the past needs a negative number: AddDays(-90)'
    }

    It 'Age is a time span' {
        ($Age -is [timespan]) | Should -BeTrue -Because 'subtracting one date from another gives a TimeSpan'
    }

    It 'AgeDays is the number of whole days' {
        $AgeDays | Should -Be 132 -Because 'the property Days of the time span between 2 November and 14 March is 132'
    }

    It 'IsStale says that the logon is older than the limit' {
        ($IsStale -is [bool]) | Should -BeTrue -Because 'a comparison returns $true or $false'
        $IsStale | Should -BeTrue -Because '2 November 2025 lies before 14 December 2025'
    }

    It 'DeleteOn is 30 days after today' {
        ([datetime]$DeleteOn).ToString('yyyy-MM-dd') | Should -Be '2026-04-13' -Because 'AddDays(30) goes forward'
    }
}
