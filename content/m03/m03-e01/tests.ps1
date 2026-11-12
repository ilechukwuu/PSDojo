param($SolutionPath)

Describe 'Read up on Stop-Process' {
    BeforeAll {
        . $SolutionPath
    }

    It 'Help holds the help for Stop-Process' {
        $Help.Name | Should -Be 'Stop-Process' -Because 'Get-Help -Name Stop-Process returns the help object of that cmdlet'
    }

    It 'Examples holds the examples view' {
        ($Examples.PSObject.TypeNames -join ' ') | Should -Match 'ExamplesView' -Because 'the switch -Examples limits the help to the examples'
    }

    It 'ForceHelp holds the help for the parameter Force' {
        $ForceHelp.name | Should -Be 'Force' -Because 'Get-Help -Parameter Force returns the details of that one parameter'
    }

    It 'IdHelp holds the help for the parameter Id' {
        $IdHelp.name | Should -Be 'Id' -Because 'Get-Help -Parameter Id returns the details of that one parameter'
    }
}
