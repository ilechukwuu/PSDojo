param($SolutionPath)

Describe 'Server name and ticket text' {
    BeforeAll {
        . $SolutionPath
        $lines = @(([string]$Body) -split "`r?`n")
    }

    It 'Fqdn has no spaces around it' {
        $Fqdn | Should -BeExactly 'fs-02.nordwind.example' -Because 'Trim() removes the spaces at both ends'
    }

    It 'ShortName is the first part in upper case' {
        $ShortName | Should -BeExactly 'FS-02' -Because 'Split returns the parts, [0] takes the first and ToUpper changes the case. Spaces in front would stay'
    }

    It 'IsInternal says that the name ends with the internal domain' {
        ($IsInternal -is [bool]) | Should -BeTrue -Because 'EndsWith answers with $true or $false'
        $IsInternal | Should -BeTrue -Because 'the cleaned name ends with .nordwind.example. Trailing spaces would make this false'
    }

    It 'Body has three lines' {
        $lines.Count | Should -Be 3 -Because 'a here-string keeps its line breaks'
    }

    It 'Body contains the inserted values and the quotes' {
        $lines[0] | Should -BeExactly 'Ticket for FS-02' -Because 'variables are replaced inside a here-string with double quotes'
        $lines[1] | Should -BeExactly 'Drive "D:" has 12 GB free.' -Because 'quotes inside a here-string need no escaping'
        $lines[2] | Should -BeExactly 'Please extend the volume.'
    }
}
