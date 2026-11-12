param($SolutionPath)

Describe 'How the pipelines for PRN-01 bind' {
    BeforeAll {
        . $SolutionPath
        function Format-Answer {
            param($Value)
            return ([string]$Value).Trim().TrimStart('-')
        }
    }

    It 'BindService: a service object binds by value' {
        Format-Answer -Value $BindService | Should -Be 'InputObject' -Because 'ByValue is tried first, and a service object has the type that -InputObject expects'
    }

    It 'BindText: a text binds by value' {
        Format-Answer -Value $BindText | Should -Be 'Name' -Because 'a text is a string, and -Name accepts strings by value'
    }

    It 'BindObject: a property named like the parameter binds by name' {
        Format-Answer -Value $BindObject | Should -Be 'Name' -Because 'the object is neither a service nor a text, so its property Name feeds the parameter -Name'
    }

    It 'BindOther: a property with another name binds nowhere' {
        Format-Answer -Value $BindOther | Should -Be 'none' -Because 'no parameter is called Service, so nothing can bind and PowerShell reports an error'
    }
}
