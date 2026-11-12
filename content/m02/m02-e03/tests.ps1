param($SolutionPath)

Describe 'Drive check for TS-03' {
    BeforeAll {
        . $SolutionPath
    }

    It 'ServerName holds the text TS-03' {
        $ServerName | Should -Be 'TS-03' -Because 'the text needs a closing quote'
    }

    It 'Drives holds the three drive letters' {
        @($Drives) -join ' ' | Should -Be 'C: D: E:' -Because 'the list starts with @( and needs a closing parenthesis'
    }

    It 'Summary holds the finished sentence' {
        $Summary | Should -Be 'Checked 3 drives on TS-03' -Because 'inside a text a property is only read within $( ), and that needs its closing parenthesis'
    }
}
