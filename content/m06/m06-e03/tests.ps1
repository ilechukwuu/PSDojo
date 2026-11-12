param($SolutionPath)

Describe 'Certificate report for WEB-01' {
    BeforeAll {
        . $SolutionPath
    }

    It 'ResultUpper is the trimmed name in upper case' {
        $ResultUpper | Should -BeExactly 'WEB-01.NORDWIND.EXAMPLE' -Because 'Trim removes the spaces, ToUpper then turns every letter into upper case'
    }

    It 'ResultSplit is the second part of the name' {
        $ResultSplit | Should -BeExactly 'nordwind' -Because 'Split returns the parts between the dots, and index 1 is the second part'
    }

    It 'ResultReplace is the name after Replace' {
        $ResultReplace | Should -BeExactly 'web-01.nordwind.example' -Because 'the method Replace is case-sensitive, and the text contains web in lower case'
    }

    It 'ResultMonth is the month fourteen days later' {
        $ResultMonth | Should -Be 1 -Because 'fourteen days after 20 December is 3 January'
    }

    It 'ResultLength is the length of the unchanged text' {
        $ResultLength | Should -Be 26 -Because 'Trim returned a new text each time, $Name itself still has its three spaces'
    }
}
