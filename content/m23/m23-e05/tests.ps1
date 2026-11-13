param($SolutionPath)

Describe 'Volumes below the warning threshold' {
    BeforeAll {
        $testVolumes = @(
            [pscustomobject]@{ Name = 'D:'; FreePercent = 40 }
            [pscustomobject]@{ Name = 'E:'; FreePercent = 22 }
            [pscustomobject]@{ Name = 'F:'; FreePercent = 9 }
        )
        $result25 = & $SolutionPath -Volumes $testVolumes -WarnPercent 25 2>$null
        $resultDefault = & $SolutionPath -Volumes $testVolumes 2>$null
    }

    It 'The script outputs one result object' {
        @($result25).Count | Should -Be 1 -Because 'the last line outputs one object with the properties Checked and Low'
    }

    It 'Low holds the volumes below 25 percent' {
        @($result25.Low) -join ', ' | Should -Be 'E:, F:' -Because 'the function has to be defined above the loop that calls it. Otherwise the call fails and nothing is found'
    }

    It 'Without -WarnPercent the default 20 applies' {
        @($resultDefault.Low) -join ', ' | Should -Be 'F:' -Because 'the param block gives $WarnPercent the default 20'
    }

    It 'Checked counts the tested volumes' {
        $result25.Checked | Should -Be 3 -Because 'an assignment inside the function creates a variable of its own. The counter of the script is reached with $script:Checked'
    }
}
