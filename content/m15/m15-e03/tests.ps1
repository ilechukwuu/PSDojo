param($SolutionPath)

Describe 'Dates for log, archive name and expiry' {
    BeforeAll {
        . $SolutionPath
    }

    It 'LogDate is the date as year-month-day' {
        $LogDate | Should -BeExactly '2026-03-14' -Because 'upper-case MM is the month, lower-case mm would be the minute'
    }

    It 'Stamp is date and time without separators' {
        $Stamp | Should -BeExactly '20260314-2205' -Because 'HH is the hour in 24-hour form and mm the minute'
    }

    It 'ArchiveName contains the stamp' {
        $ArchiveName | Should -BeExactly 'backup-20260314-2205.zip' -Because 'the stamp is inserted into the file name'
    }

    It 'Expires is 3 April 2026' {
        ($Expires -is [datetime]) | Should -BeTrue -Because 'ParseExact returns a real date object'
        ([datetime]$Expires).ToString('yyyy-MM-dd') | Should -Be '2026-04-03' -Because 'a cast reads month first and turns 03.04. into 4 March. ParseExact with dd.MM.yyyy reads it as written'
    }

    It 'DaysLeft is the number of whole days until expiry' {
        $DaysLeft | Should -Be 19 -Because 'from 14 March 22:05 to 3 April 00:00 are 19 whole days'
    }
}
