param($SolutionPath)

Describe 'Restart script for print servers' {
    BeforeAll {
        . $SolutionPath
    }

    It 'Result1: [0] on a single text is its first character' {
        [string]$Result1 | Should -BeExactly 'P' -Because 'a single text is not an array, and [0] on a text returns the first character'
    }

    It 'Result2: @( ) makes an array of the single text' {
        $Result2 | Should -BeExactly 'PRN-01' -Because 'inside @( ) the single text becomes an array with one element'
    }

    It 'Result3: an array with one element' {
        $Result3 | Should -Be 1 -Because '@( ) around one value gives an array with Count 1'
    }

    It 'Result4: a position that does not exist' {
        $Result4 | Should -BeNullOrEmpty -Because 'an index beyond the end returns nothing and no error'
    }

    It 'Result5: plus joins arrays' {
        $Result5 | Should -Be 4 -Because 'adding an element with + gives a new array with one more element'
    }

    It 'Result6: the empty array' {
        $Result6 | Should -Be 0 -Because '@() is an array without elements'
    }
}
