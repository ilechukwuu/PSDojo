param($SolutionPath)

Describe 'Rate the free space of a volume' {
    BeforeAll {
        $states = @{}
        $tickets = @{}
        foreach ($value in 5, 10, 12, 20, 55) {
            . $SolutionPath -FreePercent $value
            $states[$value] = $State
            $tickets[$value] = $NeedsTicket
        }
    }

    It 'Below 10 percent is Critical' {
        $states[5] | Should -Be 'Critical' -Because 'only the first matching block runs, so the check for below 10 must come before the check for below 20'
    }

    It 'From 10 up to below 20 percent is Warning' {
        $states[10] | Should -Be 'Warning' -Because '10 is not below 10 but below 20'
        $states[12] | Should -Be 'Warning'
    }

    It 'From 20 percent on is OK' {
        $states[20] | Should -Be 'OK' -Because 'the else block catches everything that is not below 20'
        $states[55] | Should -Be 'OK'
    }

    It 'NeedsTicket is true unless the state is OK' {
        $tickets[5] | Should -BeTrue -Because 'a critical volume needs a ticket'
        $tickets[12] | Should -BeTrue -Because 'a warning needs a ticket'
        $tickets[55] | Should -BeFalse -Because 'a healthy volume needs no ticket'
    }
}
