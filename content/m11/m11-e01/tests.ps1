param($SolutionPath)

Describe 'Check script for the Nordwind services' {
    BeforeAll {
        . (Join-Path -Path $PSScriptRoot -ChildPath '../../_shared/Stubs.ps1')
        . (Join-Path -Path $PSScriptRoot -ChildPath '../../_shared/Fixtures.ps1')
        Mock Get-Service { Get-DojoService -Name $Name }
        $result = @(& $SolutionPath 6>$null)
        $everything = @(& $SolutionPath 6>&1)
        $messages = @($everything | Where-Object { $_ -is [System.Management.Automation.InformationRecord] } | ForEach-Object { [string]$_ })
    }

    It 'The result consists of the three names and nothing else' {
        $result -join ', ' | Should -Be 'NordwindApi, NordwindSync, NordwindPrint' -Because 'only data belongs in the result. Text written with Write-Output becomes part of it, text written with Write-Host does not'
    }

    It 'The names are plain text' {
        $type = if ($result.Count -eq 0) { 'nothing' } else { $result[0].GetType().Name }
        $type | Should -Be 'String' -Because 'Select-Object -ExpandProperty Name returns the names as text'
    }

    It 'The heading is written for the person at the screen' {
        $messages | Should -Contain 'Nordwind service check for APP-01' -Because 'Write-Host writes a message that is not part of the result'
    }

    It 'The closing line is written for the person at the screen' {
        $messages | Should -Contain 'Check finished' -Because 'Write-Host writes a message that is not part of the result'
    }
}
