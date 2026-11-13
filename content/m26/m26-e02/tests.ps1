param($SolutionPath)

Describe 'A backup plan that rejects wrong input' {
    BeforeAll {
        . $SolutionPath
        $command = Get-Command -Name Get-BackupPlan -CommandType Function
        $mandatory = $false
        $parameter = $command.Parameters['ComputerName']
        if ($null -ne $parameter) {
            $mandatory = @($parameter.Attributes | Where-Object { $_ -is [System.Management.Automation.ParameterAttribute] -and $_.Mandatory }).Count -gt 0
        }
        $plan = Get-BackupPlan -ComputerName 'FS-02'
        $custom = Get-BackupPlan -ComputerName 'WEB-01' -Type 'Log' -RetentionDays 90
    }

    It 'A valid call returns the plan with the defaults' {
        $plan.ComputerName | Should -Be 'FS-02' -Because 'the function returns an object with the three values'
        $plan.Type | Should -Be 'Full' -Because 'the default of $Type is Full'
        $plan.RetentionDays | Should -Be 14 -Because 'the default of $RetentionDays is 14'
        $custom.RetentionDays | Should -Be 90 -Because '90 is the upper limit and still allowed'
    }

    It 'ComputerName is mandatory' {
        $mandatory | Should -BeTrue -Because '[Parameter(Mandatory)] enforces a server name'
    }

    It 'A type outside the list is rejected' {
        { Get-BackupPlan -ComputerName 'FS-02' -Type 'Weekly' } | Should -Throw -Because '[ValidateSet(...)] allows only Full, Differential and Log'
    }

    It 'A retention outside 1 to 90 is rejected' {
        { Get-BackupPlan -ComputerName 'FS-02' -RetentionDays 0 } | Should -Throw -Because '[ValidateRange(1, 90)] rejects 0'
        { Get-BackupPlan -ComputerName 'FS-02' -RetentionDays 91 } | Should -Throw -Because '[ValidateRange(1, 90)] rejects 91'
    }

    It 'A name that only contains a valid name is rejected' {
        { Get-BackupPlan -ComputerName 'laptop7' } | Should -Throw -Because '[ValidatePattern(...)] allows only FS-, APP- or WEB- with two digits'
        { Get-BackupPlan -ComputerName 'OLD-FS-021' } | Should -Throw -Because 'the pattern has to cover the whole name. Without ^ and $ a match somewhere inside is enough'
    }
}
