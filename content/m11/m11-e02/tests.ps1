param($SolutionPath)

Describe 'Check for APP-01 with warning and verbose message' {
    BeforeAll {
        . (Join-Path -Path $PSScriptRoot -ChildPath '../../_shared/Stubs.ps1')
        . (Join-Path -Path $PSScriptRoot -ChildPath '../../_shared/Fixtures.ps1')
        Mock Get-Service { Get-DojoService -Name $Name }
        $VerbosePreference = 'Continue'
        $everything = @(& $SolutionPath 3>&1 4>&1 6>&1)
        $VerbosePreference = 'SilentlyContinue'
        $quiet = @(& $SolutionPath 3>&1 4>&1 6>&1)
        $verbose = @($everything | Where-Object { $_ -is [System.Management.Automation.VerboseRecord] } | ForEach-Object { $_.Message })
        $warnings = @($everything | Where-Object { $_ -is [System.Management.Automation.WarningRecord] } | ForEach-Object { $_.Message })
        $result = @($everything | Where-Object { $_ -is [string] })
        $quietNoise = @($quiet | Where-Object { $_ -is [System.Management.Automation.InformationRecord] -or $_ -is [System.Management.Automation.VerboseRecord] })
    }

    It 'The verbose message is written' {
        $verbose | Should -Contain 'Reading services from APP-01' -Because 'Write-Verbose writes the progress note to the verbose stream'
    }

    It 'The script is quiet when verbose output is off' {
        $quietNoise.Count | Should -Be 0 -Because 'a progress note written with Write-Verbose stays hidden by default, one written with Write-Host always appears'
    }

    It 'The warning names the number of services' {
        $warnings | Should -Contain 'Stopped automatic services: 3' -Because 'Write-Warning writes the text with the value of $Count'
    }

    It 'The result consists of the three names' {
        ($result | Sort-Object) -join ', ' | Should -Be 'NordwindPrint, NordwindSync, SQLSERVERAGENT' -Because 'the names of the services in $Broken are the result of the script'
    }
}
