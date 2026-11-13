param($SolutionPath)

Describe 'Path expressions of the backup script' {
    BeforeAll {
        . $SolutionPath
    }

    It 'Result1: the leaf is the file name' {
        ([string]$Result1).Trim() | Should -Be 'nordwind-2026.tar.gz' -Because '-Leaf returns the part after the last separator'
    }

    It 'Result2: the parent is the folder path' {
        ([string]$Result2).Trim().TrimEnd('\') | Should -Be 'D:\Backup\sql' -Because '-Parent returns everything before the last separator'
    }

    It 'Result3: BaseName removes only the last extension' {
        ([string]$Result3).Trim() | Should -Be 'nordwind-2026.tar' -Because 'only the part from the last dot on is the extension, so .tar stays in the BaseName'
    }

    It 'Result4: Extension starts at the last dot' {
        ([string]$Result4).Trim() | Should -Be '.gz' -Because 'the extension is the part from the last dot on, including the dot'
    }

    It 'Result5: a file is not a container' {
        ($Result5 -is [bool]) | Should -BeTrue -Because 'Test-Path answers with $true or $false'
        $Result5 | Should -BeFalse -Because 'the path exists but is a file, and -PathType Container asks for a folder'
    }

    It 'Result6: Join-Path leaves exactly one separator' {
        ([string]$Result6).Trim() | Should -Be 'D:\Backup\sql' -Because 'Join-Path removes the doubled separator between folder and child'
    }
}
