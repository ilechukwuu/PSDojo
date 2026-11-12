param($SolutionPath)

Describe 'A drive for the finance reports' {
    BeforeAll {
        $root = Join-Path -Path $TestDrive -ChildPath 'finance'
        $null = New-Item -Path $root -ItemType Directory -Force
        Set-Content -LiteralPath (Join-Path -Path $root -ChildPath '2026-02.csv') -Value 'a;b'
        Set-Content -LiteralPath (Join-Path -Path $root -ChildPath '2026-03.csv') -Value 'a;b'
        Remove-PSDrive -Name Reports -ErrorAction SilentlyContinue
        . $SolutionPath -Root $root 2>$null
        $drive = Get-PSDrive -Name Reports -ErrorAction SilentlyContinue
    }

    AfterAll {
        Remove-PSDrive -Name Reports -ErrorAction SilentlyContinue
    }

    It 'The drive Reports exists and uses the file system provider' {
        $drive | Should -Not -BeNullOrEmpty -Because 'New-PSDrive -Name Reports creates the drive'
        $drive.Provider.Name | Should -Be 'FileSystem'
    }

    It 'The drive points at the folder the dojo passed' {
        $drive.Root.TrimEnd('\', '/') | Should -Be $root.TrimEnd('\', '/') -Because 'the root of the drive is the value of $Root'
    }

    It 'ReportFiles holds the files of the drive' {
        (@($ReportFiles).Name | Sort-Object) -join ', ' | Should -Be '2026-02.csv, 2026-03.csv' -Because 'the path of a drive is its name followed by a colon, here Reports:'
    }

    It 'HasMarch says that the March report exists' {
        $HasMarch | Should -BeTrue -Because 'Test-Path -Path Reports:2026-03.csv checks the file on the new drive'
    }
}
