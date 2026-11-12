param($SolutionPath)

Describe 'Stopped services on APP-01 in three shapes' {
    BeforeAll {
        . (Join-Path -Path $PSScriptRoot -ChildPath '../../_shared/Stubs.ps1')
        . (Join-Path -Path $PSScriptRoot -ChildPath '../../_shared/Fixtures.ps1')
        $script:calls = 0
        Mock Get-Service {
            $script:calls++
            Get-DojoService -Name $Name
        }
        . $SolutionPath
        $callCount = $script:calls
    }

    It 'Table, List and Count are unchanged' {
        $Table | Should -Match 'BITS\s+Manual' -Because 'the behavior must not change'
        $List | Should -Match 'DisplayName\s*:\s*Windows Time' -Because 'the behavior must not change'
        $Count | Should -Be 6 -Because 'the behavior must not change'
    }

    It 'Get-Service is called exactly once' {
        $callCount | Should -Be 1 -Because 'the data is fetched once and every view starts from the variable'
    }

    It 'Stopped holds service objects, not formatted output' {
        (@($Stopped).Name) -join ', ' | Should -Be 'BITS, NordwindPrint, NordwindSync, RemoteRegistry, SQLSERVERAGENT, W32Time' -Because 'the data layer never contains a Format- cmdlet, so the variable stays usable as data'
    }
}
