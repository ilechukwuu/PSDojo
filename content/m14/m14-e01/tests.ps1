param($SolutionPath)

Describe 'Texts for the disk warning mail' {
    BeforeAll {
        . $SolutionPath
    }

    It 'Subject contains the server name' {
        $Subject | Should -BeExactly 'Disk warning for FS-02' -Because 'double quotes replace the variable $Server with its value'
    }

    It 'Line contains the two properties' {
        $Line | Should -BeExactly 'Drive D: has 75 GB free' -Because 'a property inside a text is only read within $( ), otherwise the whole object is inserted'
    }

    It 'LogName joins server and year with an underscore' {
        $LogName | Should -BeExactly 'FS-02_2026.log' -Because 'an underscore directly after the name belongs to the name unless curly braces mark its end: ${Server}'
    }

    It 'Hint keeps its dollar sign' {
        $Hint | Should -BeExactly 'Set $Limit in config.psd1' -Because 'single quotes take every character literally'
    }
}
