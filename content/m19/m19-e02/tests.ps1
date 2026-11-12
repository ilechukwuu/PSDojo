param($SolutionPath)

Describe 'State of the services as lines' {
    BeforeAll {
        . (Join-Path -Path $PSScriptRoot -ChildPath '../../_shared/Stubs.ps1')
        . (Join-Path -Path $PSScriptRoot -ChildPath '../../_shared/Fixtures.ps1')
        Mock Get-Service { Get-DojoService -Name $Name }
        . $SolutionPath
    }

    It 'Lines holds one text per Nordwind service' {
        @($Lines).Count | Should -Be 3 -Because 'the block of ForEach-Object runs once per service'
        @($Lines)[0] | Should -BeExactly 'NordwindApi is Running' -Because 'a property of $_ inside a text needs $( ), otherwise the whole object is inserted'
        @($Lines)[1] | Should -BeExactly 'NordwindSync is Stopped'
    }

    It 'StoppedNames holds the stopped services in upper case' {
        (@($StoppedNames) | Sort-Object) -join ', ' | Should -BeExactly 'BITS, NORDWINDPRINT, NORDWINDSYNC, REMOTEREGISTRY, SQLSERVERAGENT, W32TIME' -Because 'the filter keeps the stopped services and the block turns each name into upper case'
    }
}
