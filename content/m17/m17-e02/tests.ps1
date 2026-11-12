param($SolutionPath)

Describe 'Site and team for a ticket' {
    BeforeAll {
        . $SolutionPath
    }

    It 'SiteOf translates servers into sites' {
        $SiteOf['FS-01'] | Should -Be 'Kiel' -Because 'the table holds one pair per server'
        $SiteOf['FS-02'] | Should -Be 'Hamburg'
        $SiteOf.Count | Should -Be 3
    }

    It 'TeamOf translates sites into teams' {
        $TeamOf['Kiel'] | Should -Be 'Team North' -Because 'the table holds one pair per site'
        $TeamOf.Count | Should -Be 2
    }

    It 'Site is looked up with the ticket server' {
        $Site | Should -Be 'Hamburg' -Because 'the key comes from the variable: $SiteOf[$TicketServer]. In quotes it would be the literal word'
    }

    It 'Team is looked up with the site' {
        $Team | Should -Be 'Team Elbe' -Because 'the second lookup uses the result of the first as its key'
    }

    It 'Line names server, site and team' {
        $Line | Should -Be 'PRN-01 / Hamburg / Team Elbe' -Because 'the three variables are inserted into one text'
    }
}
