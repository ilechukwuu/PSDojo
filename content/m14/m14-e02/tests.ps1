param($SolutionPath)

Describe 'Strange texts in the report mail' {
    BeforeAll {
        . $SolutionPath
    }

    It 'Text1: a variable in double quotes is replaced' {
        $Text1 | Should -BeExactly 'Server: PRN-01' -Because 'double quotes replace the variable with its value'
    }

    It 'Text2: single quotes replace nothing' {
        $Text2 | Should -BeExactly 'Server: $Server' -Because 'single quotes take the text literally'
    }

    It 'Text3: the dot ends the variable name' {
        ($Text3 -replace '\s', '') | Should -BeExactly 'Jobs:@{Jobs=14}.Jobs' -Because 'only $Queue is replaced, by the whole object as text, and .Jobs stays as plain text'
    }

    It 'Text4: $( ) evaluates the property' {
        $Text4 | Should -BeExactly 'Jobs: 14' -Because 'inside $( ) the property is read first'
    }

    It 'Text5: the underscore belongs to the variable name' {
        $Text5 | Should -BeExactly '.txt' -Because 'PowerShell looks for a variable named Server_report, finds none and inserts nothing'
    }

    It 'Text6: a method call inside $( )' {
        $Text6 | Should -BeExactly 'prn-01.nordwind.example' -Because 'the method is called inside $( ) and the rest of the text follows'
    }
}
