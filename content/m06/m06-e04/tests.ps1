param($SolutionPath)

Describe 'Maintenance announcement for FS-02' {
    BeforeAll {
        . $SolutionPath
    }

    It 'Upper holds the server name in upper case' {
        $type = if ($null -eq $Upper) { 'nothing' } else { $Upper.GetType().Name }
        $type | Should -Be 'String' -Because 'a method without parentheses returns its description. ToUpper() with parentheses returns the text'
        $Upper | Should -BeExactly 'FS-02'
    }

    It 'NameLength holds the number of characters' {
        $NameLength | Should -Be 5 -Because 'Length is a property and is read without parentheses'
    }

    It 'End is seven days after the start' {
        $End.ToString('yyyy-MM-dd HH:mm') | Should -Be '2026-03-21 22:00' -Because 'the argument of a method goes inside the parentheses: AddDays(7)'
    }
}
