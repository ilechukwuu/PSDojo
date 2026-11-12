param($SolutionPath)

Describe 'Certificate check for WEB-01' {
    BeforeAll {
        . $SolutionPath
    }

    It 'Expires is 3 April 2026' {
        ([datetime]$Expires).ToString('yyyy-MM-dd') | Should -Be '2026-04-03' -Because 'a cast reads the month first and turns 03.04.2026 into 4 March. The layout must be given with ParseExact'
    }

    It 'WarnFrom is 30 days before the expiry' {
        ([datetime]$WarnFrom).ToString('yyyy-MM-dd') | Should -Be '2026-03-04' -Because 'the warning period starts before the expiry, that is AddDays(-30)'
    }

    It 'ShouldWarn is true' {
        ($ShouldWarn -is [bool]) | Should -BeTrue -Because 'a comparison returns $true or $false'
        $ShouldWarn | Should -BeTrue -Because '14 March lies after 4 March. The comparison must use the date objects, texts are compared character by character'
    }
}
