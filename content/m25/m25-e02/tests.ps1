param($SolutionPath)

Describe 'One function for the status of a volume' {
    BeforeAll {
        . $SolutionPath
        $command = Get-Command -Name Get-VolumeStatus -CommandType Function -ErrorAction SilentlyContinue
        $low = $null
        $custom = $null
        if ($null -ne $command) {
            $low = Get-VolumeStatus -Name 'D:' -FreePercent 12
            $custom = Get-VolumeStatus -Name 'D:' -FreePercent 12 -WarnPercent 10
        }
    }

    It 'The function Get-VolumeStatus exists' {
        $command | Should -Not -BeNullOrEmpty -Because 'function Get-VolumeStatus { ... } defines the command'
    }

    It 'It returns an object with three properties' {
        ($low -is [string]) | Should -BeFalse -Because 'a function returns an object with properties. A formatted text cannot be sorted or filtered by the caller'
        @($low.PSObject.Properties.Name) -join ', ' | Should -Be 'Name, FreePercent, Status' -Because 'the object is built with [pscustomobject]@{ ... } in this order'
    }

    It 'Without -WarnPercent the default 20 applies' {
        $low.Status | Should -Be 'low' -Because '12 percent is below the default warning value of 20'
        $low.FreePercent | Should -Be 12
    }

    It 'With -WarnPercent 10 the same volume is ok' {
        $custom.Status | Should -Be 'ok' -Because '12 percent is not below a warning value of 10'
    }

    It 'Status holds the result for E:' {
        $Status.Name | Should -Be 'E:' -Because 'the function was called with -Name E:'
        $Status.Status | Should -Be 'ok'
    }
}
