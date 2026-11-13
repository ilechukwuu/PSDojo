param($SolutionPath)

Describe 'Disk check controlled by parameters' {
    BeforeAll {
        . $SolutionPath
        $defaultName = $ComputerName
        $defaultWarn = $WarnPercent
        $defaultMode = $Mode

        $ComputerName = $null
        $WarnPercent = $null
        $Mode = $null
        . $SolutionPath -ComputerName 'FS-02' -WarnPercent '15' -Detailed
        $warnType = if ($null -eq $WarnPercent) { 'nothing' } else { $WarnPercent.GetType().Name }
    }

    It 'Without arguments the defaults apply' {
        $defaultName | Should -Be 'FS-01' -Because 'the param block gives $ComputerName the default FS-01'
        $defaultWarn | Should -Be 20 -Because 'the param block gives $WarnPercent the default 20'
        $defaultMode | Should -Be 'short' -Because 'without the switch the mode is short'
    }

    It 'Arguments replace the defaults' {
        $ComputerName | Should -Be 'FS-02' -Because 'the caller passed -ComputerName FS-02'
        $WarnPercent | Should -Be 15
    }

    It 'WarnPercent is converted to a whole number' {
        $warnType | Should -Be 'Int32' -Because 'the parameter needs the type [int] in front, so that the text 15 from the caller becomes a number'
    }

    It 'The switch sets the mode to detailed' {
        $Mode | Should -Be 'detailed' -Because 'the switch $Detailed is true when the caller writes -Detailed'
    }
}
