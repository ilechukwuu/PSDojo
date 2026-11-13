param($SolutionPath)

Describe 'A table of health checks' {
    BeforeAll {
        $Healthy = $null
        . $SolutionPath -CheckName 'Disk' -Value 9
        $diskLow = $Healthy
        $Healthy = $null
        . $SolutionPath -CheckName 'Latency' -Value 150
        $latencyGood = $Healthy
        $Healthy = $null
        . $SolutionPath -CheckName 'Memory' -Value 10
        $memoryGood = $Healthy

        $blockCount = 0
        $keys = ''
        if ($Checks -is [hashtable]) {
            $blockCount = @($Checks.Values | Where-Object { $_ -is [scriptblock] }).Count
            $keys = ($Checks.Keys | Sort-Object) -join ', '
        }
        $ast = [System.Management.Automation.Language.Parser]::ParseFile($SolutionPath, [ref]$null, [ref]$null)
        $ifCount = @($ast.FindAll({ param($node) $node -is [System.Management.Automation.Language.IfStatementAst] }, $true)).Count
    }

    It 'The results are the same as before' {
        $diskLow | Should -BeFalse -Because 'a disk value of 9 is below the limit of 15'
        $latencyGood | Should -BeTrue -Because 'a latency of 150 is within the limit of 200'
        $memoryGood | Should -BeTrue -Because 'a memory value of 10 reaches the limit of 10'
    }

    It 'Checks is a table with the three names' {
        $keys | Should -Be 'Disk, Latency, Memory' -Because 'the hashtable $Checks has one key per kind of check'
    }

    It 'Every entry of the table is a script block' {
        $blockCount | Should -Be 3 -Because 'the values have to be code in braces. A comparison in parentheses is computed immediately and only its result is stored'
    }

    It 'A block from the table can be invoked with another value' {
        (& $Checks['Latency'] 500) | Should -BeFalse -Because 'each block takes the value through param($Value)'
    }

    It 'No if remains' {
        $ifCount | Should -Be 0 -Because 'the lookup in the table replaces the chain'
    }
}
