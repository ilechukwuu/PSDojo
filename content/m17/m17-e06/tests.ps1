param($SolutionPath)

Describe 'Log search for APP-01' {
    BeforeAll {
        $root = Join-Path -Path $TestDrive -ChildPath 'app01'
        $null = New-Item -Path (Join-Path -Path $root -ChildPath 'iis') -ItemType Directory -Force
        $null = New-Item -Path (Join-Path -Path $root -ChildPath 'old.log') -ItemType Directory -Force
        Set-Content -LiteralPath (Join-Path -Path $root -ChildPath 'app.log') -Value 'x'
        Set-Content -LiteralPath (Join-Path -Path $root -ChildPath 'iis/u_ex260314.log') -Value 'x'
        . $SolutionPath -Root $root

        $ast = [System.Management.Automation.Language.Parser]::ParseFile($SolutionPath, [ref]$null, [ref]$null)
        $call = @($ast.FindAll({ param($node) $node -is [System.Management.Automation.Language.CommandAst] -and $node.GetCommandName() -eq 'Get-ChildItem' }, $true))[0]
        $elements = @($call.CommandElements | Select-Object -Skip 1)
        $splatted = @($elements | Where-Object { $_ -is [System.Management.Automation.Language.VariableExpressionAst] -and $_.Splatted })
        $named = @($elements | Where-Object { $_ -is [System.Management.Automation.Language.CommandParameterAst] })
    }

    It 'Logs still holds the two log files' {
        (@($Logs).Name | Sort-Object) -join ', ' | Should -Be 'app.log, u_ex260314.log' -Because 'the behavior must not change. All five parameters of the original line belong in the hashtable, the switches with the value $true'
    }

    It 'LogSearch holds the five parameters' {
        ($LogSearch.Keys | Sort-Object) -join ', ' | Should -Be 'ErrorAction, File, Filter, Path, Recurse' -Because 'each parameter of the original line becomes one key'
    }

    It 'Get-ChildItem is called with the splatted hashtable only' {
        $splatted.Count | Should -Be 1 -Because 'the hashtable is passed with @LogSearch'
        $named.Count | Should -Be 0 -Because 'no parameter is written in the call itself any more'
    }
}
