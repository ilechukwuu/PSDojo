param($SolutionPath)

Describe 'Volumes that are running low' {
    BeforeAll {
        $folder = Join-Path -Path $TestDrive -ChildPath 'capacity'
        $null = New-Item -Path $folder -ItemType Directory -Force
        Set-Content -LiteralPath (Join-Path -Path $folder -ChildPath 'disks.csv') -Encoding UTF8 -Value @(
            'Server;Drive;FreeGB'
            'FS-01;D:;210'
            'FS-02;D:;9'
            'FS-03;E:;100'
            'FS-04;D:;15'
        )
        . $SolutionPath -Folder $folder
        $outFile = Join-Path -Path $folder -ChildPath 'low.csv'
        $written = @()
        $firstLine = ''
        if (Test-Path -LiteralPath $outFile) {
            $written = @(Import-Csv -LiteralPath $outFile -Delimiter ';')
            $firstLine = @(Get-Content -LiteralPath $outFile -Encoding UTF8)[0]
        }
    }

    It 'Rows holds the four rows with three columns' {
        @($Rows).Count | Should -Be 4 -Because 'Import-Csv returns one object per line'
        @($Rows)[0].Server | Should -Be 'FS-01' -Because 'the file is separated by semicolons, so Import-Csv needs -Delimiter'
    }

    It 'Low holds the two volumes below 20 GB' {
        (@($Low).Server | Sort-Object) -join ', ' | Should -Be 'FS-02, FS-04' -Because 'values from a CSV file are text. As text 100 is less than 20, so the value must be converted with [int]'
    }

    It 'low.csv holds the same two rows' {
        ($written.Server | Sort-Object) -join ', ' | Should -Be 'FS-02, FS-04' -Because 'Export-Csv writes the rows of $Low with the delimiter ;'
        $written[0].PSObject.Properties.Name -join ', ' | Should -Be 'Server, Drive, FreeGB'
    }

    It 'low.csv has no type line' {
        $firstLine | Should -Not -Match '^#TYPE' -Because 'Windows PowerShell 5.1 writes a type line unless -NoTypeInformation is given'
    }
}
