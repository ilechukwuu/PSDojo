param($SolutionPath)

Describe 'Review of the commands for FS-02' {
    BeforeAll {
        . $SolutionPath
    }

    It 'ChangingCount is the number of commands that change the server' {
        $ChangingCount | Should -Be 4 -Because 'every verb except Get changes something, and creating a share is a change too'
    }

    It 'ReadOnlyVerb is the verb that only reads' {
        ([string]$ReadOnlyVerb).Trim() | Should -Be 'Get' -Because 'the answer is the verb alone, without hyphen and noun'
    }

    It 'RestartCommand is the name built from verb and noun' {
        ([string]$RestartCommand).Trim() | Should -Be 'Restart-Service' -Because 'a cmdlet name is verb, hyphen, noun'
    }
}
