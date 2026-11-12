param($SolutionPath)

Describe 'Taking stock of a server' {
    BeforeAll {
        . $SolutionPath 2>$null
    }

    It 'Providers holds the providers' {
        @($Providers).Name | Should -Contain 'FileSystem' -Because 'Get-PSProvider lists the providers'
        @($Providers).Name | Should -Contain 'Environment'
    }

    It 'Drives holds drives of several providers' {
        @($Drives).Name | Should -Contain 'Env' -Because 'Get-PSDrive without parameters lists every drive'
        @($Drives).Name | Should -Contain 'Alias'
    }

    It 'DiskDrives holds file system drives only' {
        @($DiskDrives).Count | Should -BeGreaterThan 0 -Because 'FileSystem is a provider, so the filter is -PSProvider and not -Name'
        $other = @($DiskDrives | Where-Object { $_.Provider.Name -ne 'FileSystem' }).Name -join ', '
        $other | Should -Be '' -Because 'only drives of the provider FileSystem belong in the list'
    }

    It 'EnvDrive is the drive Env' {
        $EnvDrive.Name | Should -Be 'Env' -Because 'Get-PSDrive -Name Env returns that one drive'
        $EnvDrive.Provider.Name | Should -Be 'Environment'
    }
}
