param($SolutionPath)

Describe 'Calling and dot-sourcing the settings file' {
    BeforeAll {
        $testFolder = Join-Path -Path $TestDrive -ChildPath 'maintenance'
        $null = New-Item -Path $testFolder -ItemType Directory -Force
        Set-Content -LiteralPath (Join-Path -Path $testFolder -ChildPath 'settings.ps1') -Value @(
            '$Site = ''Hamburg'''
            '''settings loaded'''
        )
        $Site = $null
        . $SolutionPath -Folder $testFolder
    }

    It 'SettingsFile is the path of settings.ps1' {
        $SettingsFile | Should -Be (Join-Path -Path $testFolder -ChildPath 'settings.ps1') -Because 'Join-Path builds the path from $Folder and the file name'
    }

    It 'Output holds what the called script returned' {
        @($Output) -join '' | Should -Be 'settings loaded' -Because 'the call operator & runs the script and its output can be assigned'
    }

    It 'After the call Site is still empty' {
        ($null -eq $AfterCall) | Should -BeTrue -Because 'a called script runs in its own scope, and its variables are gone when it ends'
    }

    It 'After dot-sourcing Site is set' {
        $AfterDot | Should -Be 'Hamburg' -Because 'dot-sourcing runs the script in the current scope, so its variables remain. The call operator does not do that'
    }
}
