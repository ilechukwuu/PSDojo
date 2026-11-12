param($SolutionPath)

Describe 'Backup script for FS-02' {
    BeforeAll {
        . $SolutionPath
    }

    It 'Subject contains the server name' {
        $Subject | Should -BeExactly 'Backup of FS-02 finished' -Because 'single quotes replace nothing, the variable needs double quotes'
    }

    It 'Summary contains the size' {
        $Summary | Should -BeExactly 'Size: 42 GB' -Because 'a property inside a text needs $( ) around it'
    }

    It 'FileName starts with the server name' {
        $FileName | Should -BeExactly 'FS-02_full.bak' -Because 'the underscore became part of the variable name. ${Server} marks where the name ends'
    }
}
