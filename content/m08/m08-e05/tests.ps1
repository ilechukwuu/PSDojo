param($SolutionPath)

Describe 'Check that runs every minute against APP-01' {
    BeforeAll {
        . (Join-Path -Path $PSScriptRoot -ChildPath '../../_shared/Stubs.ps1')
        . (Join-Path -Path $PSScriptRoot -ChildPath '../../_shared/Fixtures.ps1')
        $script:unfiltered = 0
        $script:fetched = 0
        Mock Get-Service {
            if (-not $Name) {
                $script:unfiltered++
            }
            $result = @(Get-DojoService -Name $Name)
            $script:fetched += $result.Count
            $result
        }
        . $SolutionPath
        $unfilteredCalls = $script:unfiltered
        $fetchedObjects = $script:fetched
    }

    It 'NordwindDown still holds the stopped Nordwind services' {
        (@($NordwindDown).Name | Sort-Object) -join ', ' | Should -Be 'NordwindPrint, NordwindSync' -Because 'the behavior must not change'
    }

    It 'Sql still holds the two SQL services' {
        (@($Sql).Name | Sort-Object) -join ', ' | Should -Be 'MSSQLSERVER, SQLSERVERAGENT' -Because 'the behavior must not change'
    }

    It 'Get-Service is never called without a name filter' {
        $unfilteredCalls | Should -Be 0 -Because 'the parameter -Name filters at the source, so not every service has to be fetched'
    }

    It 'Only five services are fetched in total' {
        $fetchedObjects | Should -Be 5 -Because 'three Nordwind services and two SQL services are all the script needs'
    }
}
