param($SolutionPath)

Describe 'Audit of the cleanup script' {
    BeforeAll {
        $root = Join-Path -Path $TestDrive -ChildPath 'audit'
        $null = New-Item -Path $root -ItemType Directory -Force
        Set-Content -LiteralPath (Join-Path -Path $root -ChildPath 'stale-users.csv') -Value 'Name'
        Set-Content -LiteralPath (Join-Path -Path $root -ChildPath 'stale-computers.csv') -Value 'Name'
        . $SolutionPath -Root $root
    }

    It 'Commands holds the three command objects' {
        @($Commands).Name -join ', ' | Should -Be 'Get-ChildItem, Remove-Item, Out-File' -Because 'each text binds to the parameter -Name of Get-Command by value'
    }

    It 'Files holds file objects, not paths' {
        $type = if ($null -eq $Files) { 'nothing' } else { @($Files)[0].GetType().Name }
        $type | Should -Be 'FileInfo' -Because 'the paths must be piped into Get-Item, which returns one file object per path'
        (@($Files).Name | Sort-Object) -join ', ' | Should -Be 'stale-computers.csv, stale-users.csv'
    }

    It 'Alias holds the alias gci' {
        @($Alias).Definition -join ', ' | Should -Be 'Get-ChildItem' -Because 'the text binds to the parameter -Name of Get-Alias by value'
    }
}
