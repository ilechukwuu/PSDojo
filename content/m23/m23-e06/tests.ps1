param($SolutionPath)

Describe 'Old report files, controlled by parameters' {
    BeforeAll {
        $testFolder = Join-Path -Path $TestDrive -ChildPath 'reports'
        $null = New-Item -Path $testFolder -ItemType Directory -Force
        foreach ($entry in @(@('january.csv', 40), @('march.csv', 15), @('today.csv', 0))) {
            $file = Join-Path -Path $testFolder -ChildPath $entry[0]
            Set-Content -LiteralPath $file -Value 'Server;FreeGB'
            (Get-Item -LiteralPath $file).LastWriteTime = (Get-Date).AddDays(-$entry[1])
        }
        $names10 = @(& $SolutionPath -Path $testFolder -Days 10 2>$null | Sort-Object)
        $namesDefault = @(& $SolutionPath -Path $testFolder 2>$null | Sort-Object)

        $ast = [System.Management.Automation.Language.Parser]::ParseFile($SolutionPath, [ref]$null, [ref]$null)
        $parameters = @()
        if ($null -ne $ast.ParamBlock) { $parameters = @($ast.ParamBlock.Parameters) }
        $globals = @($ast.FindAll({ param($node) $node -is [System.Management.Automation.Language.VariableExpressionAst] -and $node.VariablePath.IsGlobal }, $true))
        $daysParameter = $parameters | Where-Object { $_.Name.VariablePath.UserPath -eq 'Days' }
    }

    It 'The script has the parameters Path and Days' {
        ($parameters | ForEach-Object { $_.Name.VariablePath.UserPath }) -join ', ' | Should -Be 'Path, Days' -Because 'the two typed-in values become parameters of a param block'
    }

    It 'With -Days 10 two files are old' {
        $names10 -join ', ' | Should -Be 'january.csv, march.csv' -Because 'the script has to use the folder and the number of days it is given'
    }

    It 'Without -Days the default 30 applies' {
        $namesDefault -join ', ' | Should -Be 'january.csv' -Because 'the value that was typed into the file becomes the default of the parameter'
    }

    It 'Days is a whole number' {
        $daysParameter.StaticType.Name | Should -Be 'Int32' -Because 'the type [int] makes PowerShell reject input that is not a number'
    }

    It 'No global variable remains' {
        $globals.Count | Should -Be 0 -Because 'a global variable stays in the session after the script has ended. The limit date is an ordinary variable'
    }
}
