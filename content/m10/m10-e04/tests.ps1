param($SolutionPath)

Describe 'Report script for APP-01' {
    BeforeAll {
        . (Join-Path -Path $PSScriptRoot -ChildPath '../../_shared/Stubs.ps1')
        . (Join-Path -Path $PSScriptRoot -ChildPath '../../_shared/Fixtures.ps1')
        Mock Get-Service { Get-DojoService -Name $Name }
        Mock Get-Process { Get-DojoProcess -Name $Name | Sort-Object -Property Name }
        . $SolutionPath 2>$null
        $topText = ($TopTable | Out-String -Width 200)
    }

    It 'Stopped holds six service objects' {
        @($Stopped).Count | Should -Be 6 -Because 'the variable is used as data later, so it must not be formatted at all'
        (@($Stopped).Status | Sort-Object -Unique) -join ', ' | Should -Be 'Stopped' -Because 'the objects must still have their property Status'
    }

    It 'Names holds the twelve names as text' {
        @($Names).Count | Should -Be 12 -Because 'Select-Object -ExpandProperty Name needs the service objects, not formatted output'
        @($Names) | Should -Contain 'Spooler'
    }

    It 'TopTable shows the two largest processes, largest first' {
        $topText | Should -Match '(?s)sqlservr.*excel' -Because 'sorting and limiting must happen before Format-Table'
        $topText | Should -Not -Match 'winword|outlook|spoolsv|rdpclip' -Because 'only the first two processes belong in the table'
    }

    It 'TopTable is a formatted table' {
        $topText | Should -Match 'Name\s+WorkingSet64' -Because 'the table is for a person, so Format-Table stays, as the last command'
    }
}
