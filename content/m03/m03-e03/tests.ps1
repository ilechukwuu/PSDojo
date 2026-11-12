param($SolutionPath)

Describe 'Which cmdlets control the encoding' {
    BeforeAll {
        . $SolutionPath 2>$null
    }

    It 'EncodingCommands holds the cmdlets with a parameter Encoding' {
        @($EncodingCommands).Name | Should -Contain 'Out-File' -Because 'the search goes by parameter name, that is -ParameterName Encoding'
        @($EncodingCommands).Name | Should -Contain 'Get-Content'
    }

    It 'EncodingCommands holds cmdlets only' {
        $other = @($EncodingCommands | Where-Object { $_.CommandType -ne 'Cmdlet' }).Name -join ', '
        $other | Should -Be '' -Because '-CommandType Cmdlet leaves out functions and aliases'
    }

    It 'ManagementCommands holds the commands of the module' {
        @($ManagementCommands).Name | Should -Contain 'Get-ChildItem' -Because '-Module Microsoft.PowerShell.Management lists the commands of that module'
        $other = @($ManagementCommands | Where-Object { $_.ModuleName -ne 'Microsoft.PowerShell.Management' }).Name -join ', '
        $other | Should -Be ''
    }

    It 'ContentParameters holds the parameter names of Get-Content' {
        @($ContentParameters) | Should -Contain 'Encoding' -Because 'the names are the Keys of the property Parameters'
        @($ContentParameters) | Should -Contain 'TotalCount'
    }

    It 'ContentModule is the module of Get-Content' {
        $ContentModule | Should -Be 'Microsoft.PowerShell.Management' -Because 'the property ModuleName of the command object names the module'
    }
}
