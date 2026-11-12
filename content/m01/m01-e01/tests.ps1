param($SolutionPath)

Describe 'Morning check on PRN-01' {
    BeforeAll {
        Mock Get-Process {
            [pscustomobject]@{ Name = 'spoolsv'; Id = 2104 }
            [pscustomobject]@{ Name = 'PrintIsolationHost'; Id = 3388 }
            [pscustomobject]@{ Name = 'lsass'; Id = 712 }
        }
        . $SolutionPath
    }

    It 'CheckTime holds a date object' {
        $type = if ($null -eq $CheckTime) { 'nothing' } else { $CheckTime.GetType().Name }
        $type | Should -Be 'DateTime' -Because 'Get-Date returns a date object. In quotes it is only text'
    }

    It 'CheckTime is the current time' {
        ([datetime]::Now - $CheckTime).TotalMinutes | Should -BeLessThan 5 -Because 'the check time is taken now, with Get-Date'
    }

    It 'Processes holds the output of Get-Process' {
        @($Processes).Name | Should -Contain 'spoolsv' -Because 'Get-Process returns one object per process. In quotes it is only text'
    }

    It 'Processes holds every process' {
        @($Processes).Count | Should -Be 3
    }

    It 'Location holds the output of Get-Location' {
        $type = if ($null -eq $Location) { 'nothing' } else { $Location.GetType().Name }
        $type | Should -Be 'PathInfo' -Because 'Get-Location returns a path object. In quotes it is only text'
    }
}
