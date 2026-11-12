param($SolutionPath)

Describe 'What a date object offers' {
    BeforeAll {
        . $SolutionPath
    }

    It 'Members holds properties and methods' {
        @($Members).Name | Should -Contain 'DayOfWeek' -Because 'Get-Date | Get-Member lists every member of the date object'
        @($Members).Name | Should -Contain 'AddDays'
    }

    It 'Properties holds properties only' {
        @($Properties).Name | Should -Contain 'DayOfWeek' -Because '-MemberType Property keeps the properties'
        @($Properties | Where-Object { $_.MemberType -ne 'Property' }).Count | Should -Be 0 -Because 'only members of the type Property belong here'
    }

    It 'Methods holds methods only' {
        @($Methods).Name | Should -Contain 'AddDays' -Because '-MemberType Method keeps the methods'
        @($Methods | Where-Object { $_.MemberType -ne 'Method' }).Count | Should -Be 0 -Because 'only members of the type Method belong here'
    }

    It 'TypeName is the type of a date object' {
        ([string]$TypeName).Trim() | Should -Be 'System.DateTime' -Because 'Get-Member prints the type name above the list of members'
    }
}
