param($SolutionPath)

Describe 'Facts for the ticket' {
    BeforeAll {
        . $SolutionPath
    }

    It 'HostName is read from the host' {
        $HostName | Should -Be $Host.Name -Because 'the value must be read with $Host.Name, a typed text is only right in one program'
    }

    It 'Major is the first number of the version' {
        $Major | Should -Be $PSVersionTable.PSVersion.Major -Because 'the first number is the property Major of $PSVersionTable.PSVersion'
    }

    It 'Major is a number' {
        ($Major -is [int]) | Should -BeTrue -Because 'the property Major is a number, not the whole version'
    }

    It 'Edition is read from the version table' {
        [string]$Edition | Should -Be ([string]$PSVersionTable.PSEdition) -Because 'the edition is the property PSEdition of $PSVersionTable'
    }
}
