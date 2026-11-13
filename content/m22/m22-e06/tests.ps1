param($SolutionPath)

Describe 'Required configuration files' {
    BeforeAll {
        $folder = Join-Path -Path $TestDrive -ChildPath 'service'
        $config = Join-Path -Path $folder -ChildPath 'config'
        $null = New-Item -Path $config -ItemType Directory -Force
        Set-Content -LiteralPath (Join-Path -Path $config -ChildPath 'app.json') -Value '{}'
        Set-Content -LiteralPath (Join-Path -Path $config -ChildPath 'license.txt') -Value 'Nordwind'
        . $SolutionPath -Root $folder
        $ast = [System.Management.Automation.Language.Parser]::ParseFile($SolutionPath, [ref]$null, [ref]$null)
        $commands = @($ast.FindAll({ param($node) $node -is [System.Management.Automation.Language.CommandAst] }, $true) | ForEach-Object { $_.GetCommandName() })
        $plus = @($ast.FindAll({ param($node) $node -is [System.Management.Automation.Language.BinaryExpressionAst] -and [string]$node.Operator -eq 'Plus' }, $true))
    }

    It 'Missing holds the one missing file' {
        @($Missing) -join ', ' | Should -Be 'hosts.csv' -Because 'app.json and license.txt exist, hosts.csv does not'
    }

    It 'Paths are built with Join-Path' {
        @($commands | Where-Object { $_ -eq 'Join-Path' }).Count | Should -BeGreaterThan 0 -Because 'Join-Path builds the paths. A path written into a text with separators is still glued together'
    }

    It 'Existence is asked with Test-Path' {
        $commands | Should -Contain 'Test-Path' -Because 'Test-Path answers in one call whether a file is there'
        $commands | Should -Not -Contain 'Get-ChildItem' -Because 'the folder no longer has to be listed'
    }

    It 'No text is glued together with plus' {
        $plus.Count | Should -Be 0 -Because 'Join-Path replaces the plus signs'
    }
}
