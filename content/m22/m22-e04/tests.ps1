param($SolutionPath)

Describe 'Backup before the update' {
    BeforeAll {
        $folder = Join-Path -Path $TestDrive -ChildPath 'nordwind'
        $config = Join-Path -Path $folder -ChildPath 'config'
        $configSub = Join-Path -Path $config -ChildPath 'db'
        $logDir = Join-Path -Path $folder -ChildPath 'logs'
        $null = New-Item -Path $configSub -ItemType Directory -Force
        $null = New-Item -Path $logDir -ItemType Directory -Force
        Set-Content -LiteralPath (Join-Path -Path $config -ChildPath 'app.json') -Value '{}'
        Set-Content -LiteralPath (Join-Path -Path $configSub -ChildPath 'connection.json') -Value '{}'
        Set-Content -LiteralPath (Join-Path -Path $logDir -ChildPath 'api.log') -Value 'api'
        Set-Content -LiteralPath (Join-Path -Path $logDir -ChildPath 'sync.log') -Value 'sync'
        Set-Content -LiteralPath (Join-Path -Path $logDir -ChildPath 'notes.txt') -Value 'notes'
        . $SolutionPath -Root $folder 2>$null
        $backup = Join-Path -Path $folder -ChildPath 'backup'
        $archive = Join-Path -Path $folder -ChildPath 'archive'
    }

    It 'backup contains the configuration with its subfolder' {
        Test-Path -LiteralPath (Join-Path -Path $backup -ChildPath 'app.json') | Should -BeTrue -Because 'Copy-Item copies the content of a folder only with -Recurse'
        Test-Path -LiteralPath (Join-Path -Path (Join-Path -Path $backup -ChildPath 'db') -ChildPath 'connection.json') | Should -BeTrue -Because '-Recurse also takes the subfolders along'
    }

    It 'archive is a folder' {
        Test-Path -LiteralPath $archive -PathType Container | Should -BeTrue -Because 'the folder has to be created before the first Move-Item. Otherwise the first log file is renamed to archive'
    }

    It 'Both log files were moved to archive' {
        $moved = @(Get-ChildItem -LiteralPath $archive -ErrorAction SilentlyContinue | Sort-Object -Property Name).Name -join ', '
        $moved | Should -Be 'api.log, sync.log' -Because 'the filter has to be *.log. The pattern .log matches no file'
        Test-Path -LiteralPath (Join-Path -Path $logDir -ChildPath 'api.log') | Should -BeFalse -Because 'Move-Item removes the file from its old place'
    }

    It 'Other files stay in logs' {
        Test-Path -LiteralPath (Join-Path -Path $logDir -ChildPath 'notes.txt') | Should -BeTrue -Because 'only log files are moved'
    }
}
