param($SolutionPath)

Describe 'One function for the lines of the morning mail' {
    BeforeAll {
        . $SolutionPath
        $command = Get-Command -Name Format-ServerLine -CommandType Function -ErrorAction SilentlyContinue
        $probe = ''
        if ($null -ne $command) {
            $probe = Format-ServerLine -Name 'TS-03' -FreeGB 49
        }
        $ast = [System.Management.Automation.Language.Parser]::ParseFile($SolutionPath, [ref]$null, [ref]$null)
        $formatCount = @($ast.FindAll({ param($node) $node -is [System.Management.Automation.Language.BinaryExpressionAst] -and [string]$node.Operator -eq 'Format' }, $true)).Count
    }

    It 'The function Format-ServerLine exists' {
        $command | Should -Not -BeNullOrEmpty -Because 'the repeated code moves into one function'
    }

    It 'Lines holds the same three lines as before' {
        @($Lines) -join ' | ' | Should -Be 'FS-01: 210 GB free (ok) | FS-02: 9 GB free (LOW) | WEB-01: 61 GB free (ok)' -Because 'the function is called once per server with the same values'
    }

    It 'The function uses only its parameters' {
        $probe | Should -Be 'TS-03: 49 GB free (LOW)' -Because 'name and free space have to come in through param. A function that reads variables of the surrounding script returns whatever was set there last'
    }

    It 'The format text appears only once' {
        $formatCount | Should -Be 1 -Because 'the line is built in one place, inside the function'
    }
}
