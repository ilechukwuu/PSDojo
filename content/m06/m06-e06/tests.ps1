param($SolutionPath)

Describe 'Processes of the line-of-business application' {
    BeforeAll {
        $script:processCount = 3
        Mock Get-Process {
            $all = @(
                [pscustomobject]@{ Name = 'nordwind.api'; Id = 3120; WorkingSet64 = 300MB }
                [pscustomobject]@{ Name = 'nordwind.sync'; Id = 3344; WorkingSet64 = 120MB }
                [pscustomobject]@{ Name = 'nordwind.ui'; Id = 4012; WorkingSet64 = 80MB }
                [pscustomobject]@{ Name = 'nordwind.print'; Id = 4410; WorkingSet64 = 20MB }
                [pscustomobject]@{ Name = 'nordwind.mail'; Id = 4518; WorkingSet64 = 10MB }
            )
            $all | Select-Object -First $script:processCount
        }
        . $SolutionPath
        $namesThree = @($Names) -join ', '
        $memoryThree = $TotalMemory

        $script:processCount = 5
        . $SolutionPath
        $namesFive = @($Names) -join ', '
        $memoryFive = $TotalMemory

        $ast = [System.Management.Automation.Language.Parser]::ParseFile($SolutionPath, [ref]$null, [ref]$null)
        $indexes = @($ast.FindAll({ param($node) $node -is [System.Management.Automation.Language.IndexExpressionAst] }, $true))
        $assigned = @($ast.FindAll({ param($node) $node -is [System.Management.Automation.Language.AssignmentStatementAst] }, $true) |
                ForEach-Object { $_.Left.Extent.Text })
    }

    It 'Names and TotalMemory are unchanged for three processes' {
        $namesThree | Should -Be 'nordwind.api, nordwind.sync, nordwind.ui' -Because 'the behavior must not change'
        $memoryThree | Should -Be 500MB -Because 'the behavior must not change'
    }

    It 'The script works for five processes too' {
        $namesFive | Should -Be 'nordwind.api, nordwind.sync, nordwind.ui, nordwind.print, nordwind.mail' -Because '$All.Name returns the name of every element, however many there are'
        $memoryFive | Should -Be 530MB -Because 'Measure-Object -Sum adds up every value that arrives'
    }

    It 'No element is picked by its position' {
        $indexes.Count | Should -Be 0 -Because 'a property read on the list returns the value from every element, positions are not needed'
    }

    It 'Only All, Names and TotalMemory are assigned' {
        ($assigned | Where-Object { '$All', '$Names', '$TotalMemory' -notcontains $_ }) -join ', ' | Should -Be '' -Because 'the helper variables are no longer needed'
    }
}
