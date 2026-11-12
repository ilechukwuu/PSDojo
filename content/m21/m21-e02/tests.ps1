param($SolutionPath)

Describe 'Settings of the disk monitoring from JSON' {
    BeforeAll {
        $folder = Join-Path -Path $TestDrive -ChildPath 'config'
        $null = New-Item -Path $folder -ItemType Directory -Force
        Set-Content -LiteralPath (Join-Path -Path $folder -ChildPath 'monitor.json') -Encoding UTF8 -Value @(
            '{'
            '  "site": "Hamburg",'
            '  "thresholds": { "warnPercent": 20, "criticalPercent": 10 },'
            '  "servers": ['
            '    { "name": "FS-01", "drives": ["C:", "D:"] },'
            '    { "name": "FS-02", "drives": ["C:", "D:", "E:"] }'
            '  ]'
            '}'
        )
        . $SolutionPath -Folder $folder 3>$null
        $copyFile = Join-Path -Path $folder -ChildPath 'copy.json'
        $copy = $null
        if (Test-Path -LiteralPath $copyFile) {
            $copy = Get-Content -LiteralPath $copyFile -Raw -Encoding UTF8 | ConvertFrom-Json
        }
    }

    It 'Config holds the settings as an object' {
        $Config.site | Should -Be 'Hamburg' -Because 'Get-Content -Raw piped into ConvertFrom-Json returns one object'
    }

    It 'WarnPercent is the nested value' {
        $WarnPercent | Should -Be 20 -Because 'nested values are reached with dots: thresholds.warnPercent'
    }

    It 'ServerNames holds both names' {
        @($ServerNames) -join ', ' | Should -Be 'FS-01, FS-02' -Because 'a property read on the list of servers returns it from every server'
    }

    It 'DriveCount is the number of drives of the second server' {
        $DriveCount | Should -Be 3 -Because 'the second server is servers[1]'
    }

    It 'copy.json still holds the drives of every server' {
        $copy | Should -Not -BeNullOrEmpty -Because 'the JSON text is saved with Set-Content'
        @($copy.servers[1].drives) -join ', ' | Should -Be 'C:, D:, E:' -Because 'the drives lie deeper than the default depth of 2. Without -Depth they are written as a flat text'
    }
}
