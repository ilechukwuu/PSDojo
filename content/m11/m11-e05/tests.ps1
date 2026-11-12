param($SolutionPath)

Describe 'Nordwind check' {
    BeforeAll {
        . (Join-Path -Path $PSScriptRoot -ChildPath '../../_shared/Stubs.ps1')
        . (Join-Path -Path $PSScriptRoot -ChildPath '../../_shared/Fixtures.ps1')
        Mock Get-Service { Get-DojoService -Name $Name }
        $quiet = @(& $SolutionPath 4>&1 6>&1)
        $VerbosePreference = 'Continue'
        $loud = @(& $SolutionPath 4>&1 6>&1)
        $VerbosePreference = 'SilentlyContinue'
        $result = @($quiet | Where-Object { $_ -is [string] })
        $hostLines = @($quiet | Where-Object { $_ -is [System.Management.Automation.InformationRecord] })
        $verbose = @($loud | Where-Object { $_ -is [System.Management.Automation.VerboseRecord] } | ForEach-Object { $_.Message })
    }

    It 'The result is unchanged' {
        $result -join ', ' | Should -Be 'NordwindSync, NordwindPrint' -Because 'the behavior must not change'
    }

    It 'The script writes nothing to the host' {
        $hostLines.Count | Should -Be 0 -Because 'every status line must be written with Write-Verbose instead of Write-Host'
    }

    It 'All four status lines are verbose messages' {
        $verbose -join ' | ' | Should -Be 'Starting Nordwind check | Reading services | Filtering stopped services | Nordwind check done' -Because 'the texts stay the same, only the cmdlet changes'
    }
}
