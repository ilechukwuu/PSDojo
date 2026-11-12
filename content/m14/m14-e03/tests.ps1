param($SolutionPath)

Describe 'Numbered server names and report lines' {
    BeforeAll {
        . $SolutionPath
    }

    It 'ServerName has a three-digit number' {
        $ServerName | Should -BeExactly 'APP-012' -Because '{0:D3} writes the number with at least three digits'
    }

    It 'Stamp is the date as text' {
        $Stamp | Should -BeExactly '2026-03-14' -Because '{0:yyyy-MM-dd} writes the date in this layout'
    }

    It 'FileName is built from two placeholders' {
        $FileName | Should -BeExactly 'report_APP-012_2026-03-14.csv' -Because '{0} takes the first value and {1} the second'
    }

    It 'Row is aligned in two columns' {
        $Row | Should -BeExactly 'APP-012       75' -Because '{0,-10} left-aligns in ten characters and {1,6} right-aligns in six'
    }
}
