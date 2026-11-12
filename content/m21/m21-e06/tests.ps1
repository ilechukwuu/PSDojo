param($SolutionPath)

Describe 'Weekly disk report as CSV' {
    BeforeAll {
        $folder = Join-Path -Path $TestDrive -ChildPath 'weekly'
        $null = New-Item -Path $folder -ItemType Directory -Force
        . $SolutionPath -Folder $folder
        $file = Join-Path -Path $folder -ChildPath 'report.csv'
        $rows = @()
        if (Test-Path -LiteralPath $file) {
            $rows = @(Import-Csv -LiteralPath $file -Delimiter ';')
        }
        $ast = [System.Management.Automation.Language.Parser]::ParseFile($SolutionPath, [ref]$null, [ref]$null)
        $commands = @($ast.FindAll({ param($node) $node -is [System.Management.Automation.Language.CommandAst] }, $true) | ForEach-Object { $_.GetCommandName() })
        $plus = @($ast.FindAll({ param($node) ($node -is [System.Management.Automation.Language.BinaryExpressionAst] -and [string]$node.Operator -eq 'Plus') -or ($node -is [System.Management.Automation.Language.AssignmentStatementAst] -and [string]$node.Operator -eq 'PlusEquals') }, $true))
    }

    It 'The file has three rows with the columns in order' {
        $rows.Count | Should -Be 3 -Because 'one row per disk is written'
        $rows[0].PSObject.Properties.Name -join ', ' | Should -Be 'Server, Note, FreeGB' -Because 'Select-Object sets the columns, and the file must be separated by semicolons so that it can be read with -Delimiter ;'
    }

    It 'A note with a semicolon stays in its column' {
        $rows[1].Note | Should -Be 'Archive; old' -Because 'Export-Csv puts values in quotes, so a semicolon inside a value does not start a new column'
        $rows[1].FreeGB | Should -Be '9'
    }

    It 'The file is written with Export-Csv' {
        $commands | Should -Contain 'Export-Csv' -Because 'Export-Csv knows the rules of the format'
        $commands | Should -Not -Contain 'Set-Content' -Because 'the hand-made lines are no longer written'
    }

    It 'No text is glued together with plus' {
        $plus.Count | Should -Be 0 -Because 'the cmdlet builds the lines'
    }
}
