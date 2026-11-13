param($SolutionPath)

Describe 'An advanced function for the helpdesk' {
    BeforeAll {
        . $SolutionPath
        $ast = [System.Management.Automation.Language.Parser]::ParseFile($SolutionPath, [ref]$null, [ref]$null)
        $function = $ast.Find({ param($node) $node -is [System.Management.Automation.Language.FunctionDefinitionAst] -and $node.Name -eq 'Get-ShareUsage' }, $true)
        $hasBinding = $false
        if ($null -ne $function -and $null -ne $function.Body.ParamBlock) {
            $hasBinding = @($function.Body.ParamBlock.Attributes | Where-Object { $_.TypeName.Name -eq 'CmdletBinding' }).Count -gt 0
        }
        $command = Get-Command -Name Get-ShareUsage -CommandType Function
        $mandatory = $false
        $parameter = $command.Parameters['ComputerName']
        if ($null -ne $parameter) {
            $mandatory = @($parameter.Attributes | Where-Object { $_ -is [System.Management.Automation.ParameterAttribute] -and $_.Mandatory }).Count -gt 0
        }
        $quiet = @(Get-ShareUsage -ComputerName 'FS-01' 4>&1 6>$null)
        $loud = @(Get-ShareUsage -ComputerName 'FS-02' -Share 'HR' -Verbose 4>&1 6>$null)
        $messages = @($loud | Where-Object { $_ -is [System.Management.Automation.VerboseRecord] })
        $objects = @($loud | Where-Object { $_ -isnot [System.Management.Automation.VerboseRecord] })
    }

    It 'The function carries CmdletBinding' {
        $hasBinding | Should -BeTrue -Because '[CmdletBinding()] directly above param makes it an advanced function'
    }

    It 'ComputerName is mandatory' {
        $mandatory | Should -BeTrue -Because '[Parameter(Mandatory)] in front of $ComputerName enforces a value'
    }

    It 'It returns one object, and Share defaults to Data' {
        $quiet.Count | Should -Be 1 -Because 'without -Verbose only the result object comes back'
        $quiet[0].ComputerName | Should -Be 'FS-01'
        $quiet[0].Share | Should -Be 'Data' -Because 'the parameter $Share has the default Data'
    }

    It 'With -Verbose the message appears in the verbose stream' {
        $messages.Count | Should -Be 1 -Because 'the status message is written with Write-Verbose. Write-Host cannot be switched on and off by the caller'
        $messages[0].Message | Should -Be 'Reading share HR on FS-02'
        $objects[0].Share | Should -Be 'HR'
    }
}
