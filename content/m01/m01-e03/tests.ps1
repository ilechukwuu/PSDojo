param($SolutionPath)

Describe 'Find the right commands for TS-03' {
    BeforeAll {
        . $SolutionPath
    }

    It 'ProcessCommands holds the commands with the noun Process' {
        @($ProcessCommands).Name | Should -Contain 'Stop-Process' -Because 'Process is the noun, so search with -Noun'
    }

    It 'ProcessCommands holds nothing but Process commands' {
        $other = @($ProcessCommands | Where-Object { $_.Noun -ne 'Process' }).Name -join ', '
        $other | Should -Be '' -Because 'only commands with the noun Process belong in the list'
    }

    It 'StopCommands holds the commands with the verb Stop' {
        @($StopCommands).Name | Should -Contain 'Stop-Process' -Because 'Stop is the verb, so search with -Verb'
    }

    It 'StopCommands holds nothing but Stop commands' {
        $other = @($StopCommands | Where-Object { $_.Verb -ne 'Stop' }).Name -join ', '
        $other | Should -Be '' -Because 'only commands with the verb Stop belong in the list'
    }

    It 'ItemCommands holds the commands whose name ends with -Item' {
        @($ItemCommands).Name | Should -Contain 'Remove-Item' -Because 'the wildcard * in front of -Item stands for any verb'
    }

    It 'ItemCommands holds nothing but -Item commands' {
        $other = @($ItemCommands | Where-Object { $_.Name -notlike '*-Item' }).Name -join ', '
        $other | Should -Be '' -Because 'only names that end with -Item belong in the list'
    }
}
