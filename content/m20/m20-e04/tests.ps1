param($SolutionPath)

Describe 'Search the backup log of FS-02' {
    BeforeAll {
        $file = Join-Path -Path $TestDrive -ChildPath 'backup.log'
        Set-Content -LiteralPath $file -Value @(
            '22:00:01 INFO Backup of FS-02 started'
            '22:00:05 INFO Target D:\Backup\full.bak'
            '22:14:40 ERROR Volume D: is full'
            '22:14:41 INFO Retrying, target DXXBackupYfullZbak'
            '22:20:10 ERROR Could not write D:\Backup\full.bak'
            '22:20:11 INFO Backup finished with problems'
        )
        . $SolutionPath -LogFile $file 2>$null
    }

    It 'Errors holds the two matches' {
        @($Errors).Count | Should -Be 2 -Because 'Select-String returns one object per matching line'
    }

    It 'ErrorCount is the number of matches' {
        $ErrorCount | Should -Be 2 -Because 'the matches are counted'
    }

    It 'FirstErrorLine is the line number of the first match' {
        $FirstErrorLine | Should -Be 3 -Because 'every match knows its LineNumber'
    }

    It 'ErrorTexts holds the text of the matching lines' {
        @($ErrorTexts) -join ' | ' | Should -Be '22:14:40 ERROR Volume D: is full | 22:20:10 ERROR Could not write D:\Backup\full.bak' -Because 'the property Line is the text of the line'
    }

    It 'PathHits holds only lines with the literal path' {
        @($PathHits).LineNumber -join ', ' | Should -Be '2, 5' -Because 'the text must be searched literally with -SimpleMatch. As a regular expression the dots match any character and the backslashes change the meaning'
    }
}
