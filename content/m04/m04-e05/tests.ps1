param($SolutionPath)

Describe 'Information about the report share' {
    BeforeAll {
        $root = Join-Path -Path $TestDrive -ChildPath 'share'
        $null = New-Item -Path (Join-Path -Path $root -ChildPath 'reports') -ItemType Directory -Force
        $null = New-Item -Path (Join-Path -Path $root -ChildPath 'archive') -ItemType Directory -Force
        Set-Content -LiteralPath (Join-Path -Path $root -ChildPath 'reports/readme.txt') -Value 'weekly reports'
        Set-Content -LiteralPath (Join-Path -Path $root -ChildPath 'reports/week11.csv') -Value 'a;b'

        $before = (Get-Location).Path
        . $SolutionPath -Root $root
        $after = (Get-Location).Path
        Set-Location -Path $before

        $ast = [System.Management.Automation.Language.Parser]::ParseFile($SolutionPath, [ref]$null, [ref]$null)
        $moves = @($ast.FindAll({ param($node) $node -is [System.Management.Automation.Language.CommandAst] }, $true) |
                ForEach-Object { $_.GetCommandName() } |
                Where-Object { 'Set-Location', 'cd', 'sl', 'chdir', 'Push-Location', 'pushd' -contains $_ })
    }

    It 'Reports still holds the two files' {
        (@($Reports).Name | Sort-Object) -join ', ' | Should -Be 'readme.txt, week11.csv' -Because 'the behavior must not change'
    }

    It 'HasArchive and Readme still hold their values' {
        $HasArchive | Should -BeTrue -Because 'the behavior must not change'
        $Readme.Name | Should -Be 'readme.txt' -Because 'the behavior must not change'
    }

    It 'The script contains no command that changes the location' {
        $moves -join ', ' | Should -Be '' -Because 'a script gives every command a full path instead of changing the location'
    }

    It 'The location is the same after the script' {
        $after | Should -Be $before -Because 'a script leaves the session where it found it'
    }
}
