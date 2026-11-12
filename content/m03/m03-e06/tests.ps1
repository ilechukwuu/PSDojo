param($SolutionPath)

Describe 'Parameters of Remove-Item' {
    BeforeAll {
        . $SolutionPath
    }

    It 'SafeParameter is the parameter that takes a name literally' {
        ([string]$SafeParameter).Trim().TrimStart('-') | Should -Be 'LiteralPath' -Because 'the parameter that does not accept wildcard characters reads [ and ] as plain characters'
    }

    It 'LiteralIsPositional says whether the name can be left out' {
        ($LiteralIsPositional -is [bool]) | Should -BeTrue -Because 'the answer is $true or $false'
        $LiteralIsPositional | Should -BeFalse -Because 'Position? Named means the parameter name must be written'
    }

    It 'IncludesSubfolders says what happens without -Recurse' {
        ($IncludesSubfolders -is [bool]) | Should -BeTrue -Because 'the answer is $true or $false'
        $IncludesSubfolders | Should -BeFalse -Because 'a switch that is left out has its default value False'
    }
}
