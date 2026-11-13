param($SolutionPath)

Describe 'A plan for stale accounts with declared validation' {
    BeforeAll {
        . $SolutionPath
        $command = Get-Command -Name Get-StaleAccountPlan -CommandType Function
        $attributes = @{}
        foreach ($name in 'Name', 'Days', 'Mode') {
            $attributes[$name] = @($command.Parameters[$name].Attributes | ForEach-Object { $_.GetType().Name })
        }
        $mandatory = @($command.Parameters['Name'].Attributes | Where-Object { $_ -is [System.Management.Automation.ParameterAttribute] -and $_.Mandatory }).Count -gt 0
        $ast = [System.Management.Automation.Language.Parser]::ParseFile($SolutionPath, [ref]$null, [ref]$null)
        $ifCount = @($ast.FindAll({ param($node) $node -is [System.Management.Automation.Language.IfStatementAst] }, $true)).Count
        $throwCount = @($ast.FindAll({ param($node) $node -is [System.Management.Automation.Language.ThrowStatementAst] }, $true)).Count
        $plan = Get-StaleAccountPlan -Name 'svc-print' -Days 365 -Mode 'Disable'
    }

    It 'The function returns the same object as before' {
        @($plan.PSObject.Properties.Name) -join ', ' | Should -Be 'Name, Days, Mode' -Because 'the result of the function does not change'
        $plan.Days | Should -Be 365 -Because '365 is the upper limit and allowed'
    }

    It 'Wrong input is still rejected' {
        { Get-StaleAccountPlan -Name 'svc-print' -Days 29 } | Should -Throw -Because 'values below 30 are not allowed'
        { Get-StaleAccountPlan -Name 'svc-print' -Mode 'Delete' } | Should -Throw -Because 'only Report and Disable are allowed'
    }

    It 'Name is mandatory' {
        $mandatory | Should -BeTrue -Because 'the empty check becomes [Parameter(Mandatory)]'
    }

    It 'Days and Mode are validated by attributes' {
        $attributes['Days'] | Should -Contain 'ValidateRangeAttribute' -Because 'the between check becomes [ValidateRange(30, 365)]'
        $attributes['Mode'] | Should -Contain 'ValidateSetAttribute' -Because 'the one-of check becomes [ValidateSet(...)]'
    }

    It 'No hand-written check remains' {
        ($ifCount + $throwCount) | Should -Be 0 -Because 'the attributes replace every if and every throw'
    }
}
