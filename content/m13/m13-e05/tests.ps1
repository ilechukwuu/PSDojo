param($SolutionPath)

Describe 'Does this service state need attention' {
    BeforeAll {
        $answers = @{}
        foreach ($state in 'Running', 'Stopped', 'Paused', 'StartPending', 'StopPending', 'ContinuePending') {
            . $SolutionPath -Status $state
            $answers[$state] = $NeedsAttention
        }
        $ast = [System.Management.Automation.Language.Parser]::ParseFile($SolutionPath, [ref]$null, [ref]$null)
        $operators = @($ast.FindAll({ param($node) $node -is [System.Management.Automation.Language.BinaryExpressionAst] }, $true) | ForEach-Object { [string]$_.Operator })
    }

    It 'Running and ContinuePending need no attention' {
        $answers['Running'] | Should -BeFalse -Because 'the behavior must not change'
        $answers['ContinuePending'] | Should -BeFalse -Because 'the behavior must not change'
    }

    It 'Stopped, Paused and StartPending need attention' {
        $answers['Stopped'] | Should -BeTrue -Because 'the behavior must not change'
        $answers['Paused'] | Should -BeTrue -Because 'the behavior must not change'
        $answers['StartPending'] | Should -BeTrue -Because 'the behavior must not change'
    }

    It 'StopPending needs attention too' {
        $answers['StopPending'] | Should -BeTrue -Because 'all four states of the original chain belong in the list'
    }

    It 'The condition uses -in and no -or' {
        $operators | Should -Contain 'Iin' -Because 'one comparison with -in replaces the whole chain'
        $operators | Should -Not -Contain 'Or' -Because 'no -or is needed any more'
    }
}
