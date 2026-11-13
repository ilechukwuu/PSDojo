param($SolutionPath)

Describe 'Names of the volumes below a threshold' {
    BeforeAll {
        $testVolumes = @(
            [pscustomobject]@{ Name = 'D:'; FreePercent = 40 }
            [pscustomobject]@{ Name = 'E:'; FreePercent = 22 }
            [pscustomobject]@{ Name = 'F:'; FreePercent = 9 }
        )
        . $SolutionPath -Volumes $testVolumes 2>$null
        $direct = @()
        if (Get-Command -Name Get-LowVolume -CommandType Function -ErrorAction SilentlyContinue) {
            $direct = @(Get-LowVolume -Volumes $testVolumes -WarnPercent 10)
        }
    }

    It 'The function returns only names' {
        $direct -join ', ' | Should -Be 'F:' -Because 'only the names belong in the result. Add returns the index of the new entry, which has to be discarded with $null ='
    }

    It 'Low holds the volumes below 30 percent' {
        @($Low) -join ', ' | Should -Be 'E:, F:' -Because 'the call needs the arguments by name, and the comparison inside needs the correctly spelled $WarnPercent'
    }
}
