param($SolutionPath)

Describe 'One function for the free space in percent' {
    BeforeAll {
        . $SolutionPath 6>$null
        $command = Get-Command -Name Get-FreePercent -CommandType Function -ErrorAction SilentlyContinue
        $named = $null
        $positional = $null
        if ($null -ne $command) {
            $named = Get-FreePercent -FreeGB 18 -SizeGB 240 6>$null
            $positional = Get-FreePercent 51 60 6>$null
        }
    }

    It 'The function Get-FreePercent exists' {
        $command | Should -Not -BeNullOrEmpty -Because 'function Get-FreePercent { ... } defines the command'
    }

    It 'It returns the rounded percentage' {
        $named | Should -Be 7.5 -Because 'the function has to output the value. Write-Host only shows it on the screen, and nothing arrives at the caller'
    }

    It 'The parameters are in the order FreeGB, SizeGB' {
        $positional | Should -Be 85 -Because 'called by position, the first value is the free space and the second the size'
    }

    It 'Percent holds the result of the call' {
        $Percent | Should -Be 25 -Because '120 of 480 GB are 25 percent, and the result of a function can be assigned'
    }
}
