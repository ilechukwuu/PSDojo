param($SolutionPath)

Describe 'Validation and rewriting of names' {
    BeforeAll {
        . $SolutionPath
    }

    It 'Result1: -match ignores case' {
        $Result1 | Should -BeTrue -Because '-match compares without regard to upper and lower case'
    }

    It 'Result2: a match anywhere in the text is enough' {
        $Result2 | Should -BeTrue -Because 'without anchors the pattern only has to occur somewhere, and FS-0234 contains FS-02'
    }

    It 'Result3: anchors demand the whole text' {
        $Result3 | Should -BeFalse -Because '^ and $ allow nothing in front and nothing after the two digits'
    }

    It 'Result4: -cmatch is case-sensitive' {
        $Result4 | Should -BeFalse -Because 'the text has FS in upper case and -cmatch looks for lower case'
    }

    It 'Result5: a dot matches every character' {
        $Result5 | Should -BeExactly '____________________' -Because 'an unescaped dot stands for any character, so all twenty characters are replaced'
    }

    It 'Result6: an escaped dot matches only dots' {
        $Result6 | Should -BeExactly 'web_nordwind_example' -Because '\. is a real dot, and -replace replaces every match'
    }

    It 'Result7: -replace replaces every match' {
        $Result7 | Should -BeExactly 'FS-00 and FS-00' -Because '\d+ matches each group of digits, and all of them are replaced'
    }
}
