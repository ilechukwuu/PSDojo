param($SolutionPath)

Describe 'Log files for the weekly report' {
    BeforeAll {
        $folder = Join-Path -Path $TestDrive -ChildPath 'logs'
        $null = New-Item -Path (Join-Path -Path $folder -ChildPath 'iis') -ItemType Directory -Force
        Set-Content -LiteralPath (Join-Path -Path $folder -ChildPath 'backup.log') -Value 'ok'
        Set-Content -LiteralPath (Join-Path -Path $folder -ChildPath 'notes.txt') -Value 'ok'
        Set-Content -LiteralPath (Join-Path -Path $folder -ChildPath 'iis/u_ex260314.log') -Value 'ok'

        . $SolutionPath -LogFolder $folder

        $ast = [System.Management.Automation.Language.Parser]::ParseFile($SolutionPath, [ref]$null, [ref]$null)
        $commands = $ast.FindAll({ param($node) $node -is [System.Management.Automation.Language.CommandAst] }, $true)
        $positional = @()
        $shortened = @()
        foreach ($command in $commands) {
            $info = Get-Command -Name $command.GetCommandName() -ErrorAction SilentlyContinue
            $elements = @($command.CommandElements | Select-Object -Skip 1)
            for ($index = 0; $index -lt $elements.Count; $index++) {
                $element = $elements[$index]
                if ($element -is [System.Management.Automation.Language.CommandParameterAst]) {
                    if ($info -and -not $info.Parameters.ContainsKey($element.ParameterName)) {
                        $shortened += '-' + $element.ParameterName
                    }
                }
                else {
                    $previous = if ($index -gt 0) { $elements[$index - 1] } else { $null }
                    if (-not ($previous -is [System.Management.Automation.Language.CommandParameterAst])) {
                        $positional += $element.Extent.Text
                    }
                }
            }
        }
    }

    It 'Logs still holds the two log files' {
        (@($Logs).Name | Sort-Object) -join ', ' | Should -Be 'backup.log, u_ex260314.log' -Because 'the behavior must not change'
    }

    It 'Stamp and ItemCommands still hold their values' {
        $Stamp | Should -Be (Get-Date -Format 'yyyyMMdd') -Because 'the behavior must not change'
        @($ItemCommands).Name | Should -Contain 'Copy-Item' -Because 'the behavior must not change'
    }

    It 'Every value has a parameter name' {
        $positional -join ', ' | Should -Be '' -Because 'in a script no value is passed by position. Get-Command -Syntax shows which parameter a position belongs to'
    }

    It 'Every parameter name is written in full' {
        $shortened -join ', ' | Should -Be '' -Because 'in a script parameter names are not shortened'
    }
}
