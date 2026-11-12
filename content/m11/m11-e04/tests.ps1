param($SolutionPath)

Describe 'Check script used by a monitoring job' {
    BeforeAll {
        . (Join-Path -Path $PSScriptRoot -ChildPath '../../_shared/Stubs.ps1')
        . (Join-Path -Path $PSScriptRoot -ChildPath '../../_shared/Fixtures.ps1')
        Mock Get-Service { Get-DojoService -Name $Name }
        $folder = Join-Path -Path $TestDrive -ChildPath 'logs'
        $null = New-Item -Path $folder -ItemType Directory -Force
        $result = @(& $SolutionPath -LogFolder $folder 3>$null 6>$null)
        $VerbosePreference = 'Continue'
        $verbose = @(& $SolutionPath -LogFolder $folder 3>$null 4>&1 6>$null | Where-Object { $_ -is [System.Management.Automation.VerboseRecord] } | ForEach-Object { $_.Message })
        $VerbosePreference = 'SilentlyContinue'
        $logFile = Join-Path -Path $folder -ChildPath 'warnings.log'
        $logText = if (Test-Path -LiteralPath $logFile) { [string](Get-Content -LiteralPath $logFile -Raw) } else { '' }
    }

    It 'The result consists of the three names and nothing else' {
        $result -join ', ' | Should -Be 'NordwindApi, NordwindSync, NordwindPrint' -Because 'the names must go to the result with Write-Output, and the status text must not be part of it'
    }

    It 'The status text is a verbose message' {
        $verbose | Should -Contain 'Reading services from APP-01' -Because 'a progress note belongs in the verbose stream, written with Write-Verbose'
    }

    It 'The warning is written to warnings.log' {
        $logText | Should -Match 'Nordwind check finished with warnings' -Because 'warnings are stream 3, so the redirection must be 3> and not 2>'
    }
}
