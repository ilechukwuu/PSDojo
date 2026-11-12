BeforeDiscovery {
    . (Join-Path -Path $PSScriptRoot -ChildPath 'TestHelpers.ps1')
    $root = Get-DojoRepoRoot
    $engineCases = @(
        foreach ($folder in 'module', 'tests') {
            foreach ($file in (Get-ChildItem -LiteralPath (Join-Path -Path $root -ChildPath $folder) -Include '*.ps1', '*.psm1', '*.psd1' -Recurse)) {
                @{ Name = $file.FullName.Substring($root.Length + 1); File = $file.FullName }
            }
        }
    )
}

Describe 'Engine file <Name>' -ForEach $engineCases {
    BeforeAll {
        $tokens = $null
        $errors = $null
        $ast = [System.Management.Automation.Language.Parser]::ParseFile($File, [ref]$tokens, [ref]$errors)
        $text = [System.IO.File]::ReadAllText($File)
    }

    It 'parses without errors' {
        @($errors).Count | Should -Be 0
    }

    It 'is plain ASCII so Windows PowerShell 5.1 and ISE read it correctly' {
        @([System.IO.File]::ReadAllBytes($File) | Where-Object { $_ -gt 127 }).Count | Should -Be 0
    }

    It 'uses no syntax that needs PowerShell 7' {
        $names = @($ast.FindAll({ param($node) $true }, $true) | ForEach-Object { $_.GetType().Name } | Sort-Object -Unique)
        $names | Should -Not -Contain 'TernaryExpressionAst'
        $names | Should -Not -Contain 'PipelineChainAst'
        $kinds = @($tokens | ForEach-Object { [string]$_.Kind } | Sort-Object -Unique)
        $kinds | Should -Not -Contain 'QuestionQuestion'
        $kinds | Should -Not -Contain 'QuestionQuestionEquals'
        $kinds | Should -Not -Contain 'QuestionDot'
        $kinds | Should -Not -Contain 'QuestionLBracket'
    }

    It 'uses nothing that ISE or Windows PowerShell 5.1 cannot handle' -Skip:($Name -like '*Compatibility.Tests.ps1') {
        $text | Should -Not -Match 'ReadKey|\$PSStyle|Write-Progress|\x1b\[|`e\[|Out-GridView|Clear-Host|\[Console\]::'
        $text | Should -Not -Match '-AsHashtable|\$IsWindows|\$IsLinux|\$IsMacOS|-Parallel|Join-String'
    }
}
