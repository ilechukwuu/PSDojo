param($SolutionPath)

Describe 'Capacity report from CSV to JSON' {
    BeforeAll {
        $folder = Join-Path -Path $TestDrive -ChildPath 'capacity'
        $null = New-Item -Path $folder -ItemType Directory -Force
        Set-Content -LiteralPath (Join-Path -Path $folder -ChildPath 'disks.csv') -Encoding UTF8 -Value @(
            'Server;Drive;FreeGB'
            'FS-01;D:;210'
            'FS-02;D:;9'
            'FS-03;E:;100'
        )
        . $SolutionPath -Folder $folder 3>$null
        $file = Join-Path -Path $folder -ChildPath 'summary.json'
        $summary = $null
        if (Test-Path -LiteralPath $file) {
            $summary = Get-Content -LiteralPath $file -Raw -Encoding UTF8 | ConvertFrom-Json
        }
    }

    It 'Rows has the three columns' {
        @($Rows)[0].PSObject.Properties.Name -join ', ' | Should -Be 'Server, Drive, FreeGB' -Because 'the file is separated by semicolons. Without -Delimiter the whole header becomes one column'
    }

    It 'TotalFree is the sum as a number' {
        $TotalFree | Should -Be 319 -Because 'CSV values are text and + joins them. Measure-Object -Sum adds them as numbers'
    }

    It 'summary.json still holds the drive of every row' {
        @($summary.Data.Rows).Drive -join ', ' | Should -Be 'D:, D:, E:' -Because 'the rows lie deeper than the default depth of 2, so ConvertTo-Json needs -Depth'
    }
}
