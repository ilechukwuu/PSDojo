param($SolutionPath)

Describe 'Facts about the usage report' {
    BeforeAll {
        $folder = Join-Path -Path $TestDrive -ChildPath 'finance'
        $null = New-Item -Path $folder -ItemType Directory -Force
        $file = Join-Path -Path $folder -ChildPath 'usage-2024-11.csv'
        [System.IO.File]::WriteAllText($file, 'server;used' + [char]10 + 'FS-02;81')
        (Get-Item -LiteralPath $file).LastWriteTime = [datetime]'2024-11-30T08:15:00'
        . $SolutionPath -ReportFile $file
    }

    It 'Size is the size of the file in bytes' {
        $Size | Should -Be 20 -Because 'the size of a file is its property Length. A misspelled property returns nothing instead of an error'
    }

    It 'Extension is the file extension' {
        $Extension | Should -Be '.csv' -Because 'the property Extension holds the ending with the dot'
    }

    It 'Year is the year of the last write' {
        $Year | Should -Be 2024 -Because 'LastWriteTime is a date, and a date has the property Year'
    }

    It 'FolderName is the name of the folder' {
        $FolderName | Should -Be 'finance' -Because 'Directory is the folder object, its property Name is the name without the path'
    }
}
