param($SolutionPath)

Describe 'Inventory of the report share' {
    BeforeAll {
        $root = Join-Path -Path $TestDrive -ChildPath 'share'
        $null = New-Item -Path $root -ItemType Directory -Force
        Set-Content -LiteralPath (Join-Path -Path $root -ChildPath 'reports') -Value 'this is a file, not a folder'
        . $SolutionPath -Root $root
        $withFile = $HasReports

        $root2 = Join-Path -Path $TestDrive -ChildPath 'share2'
        $null = New-Item -Path (Join-Path -Path $root2 -ChildPath 'reports') -ItemType Directory -Force
        . $SolutionPath -Root $root2
        $withFolder = $HasReports
    }

    It 'AliasTarget holds the cmdlet behind gci' {
        $AliasTarget | Should -Be 'Get-ChildItem' -Because 'the path ends at the item, the property Definition is read from the object with a dot'
    }

    It 'HasReports is true for a folder named reports' {
        $withFolder | Should -BeTrue -Because 'the folder exists, and -PathType Container asks for a folder'
    }

    It 'HasReports is false when reports is a file' {
        $withFile | Should -BeFalse -Because 'Test-Path alone is also true for a file. -PathType Container makes sure it is a folder'
    }

    It 'The folder archive was created' {
        Test-Path -LiteralPath (Join-Path -Path $root2 -ChildPath 'archive') -PathType Container | Should -BeTrue -Because 'New-Item creates a folder with -ItemType Directory'
        $Archive.Name | Should -Be 'archive'
    }
}
