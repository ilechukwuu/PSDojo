param($SolutionPath)

Describe 'What the inventory helpers really return' {
    BeforeAll {
        . $SolutionPath
    }

    It 'Result1: the function returns three values' {
        $Result1 | Should -Be 3 -Because 'each Add outputs the index of the new entry, and both land in the result in front of the count'
    }

    It 'Result2: the third value is the count' {
        $Result2 | Should -Be 2 -Because 'the result is 0, 1, 2. The count comes last'
    }

    It 'Result3: return leaves at the first match' {
        ([string]$Result3).Trim() | Should -Be 'FS-02' -Because 'return ends the function at the first name that starts with FS-'
    }

    It 'Result4: named arguments' {
        ([string]$Result4).Trim() | Should -Be 'Kiel|FS-01' -Because 'each value goes to the parameter that is named'
    }

    It 'Result5: parentheses pass one array' {
        ([string]$Result5).Trim() | Should -Be 'Kiel FS-01|' -Because 'the parentheses and the comma build one array, which goes to $Site. In a text its entries are joined with a space, and $Server stays empty'
    }
}
