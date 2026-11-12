param($SolutionPath)

Describe 'Handover documentation for FS-02' {
    BeforeAll {
        . $SolutionPath
    }

    It 'DirAliases holds the aliases of Get-ChildItem' {
        @($DirAliases).Name | Should -Contain 'gci' -Because 'Get-Alias searches by cmdlet with the parameter -Definition'
    }

    It 'FirstThree holds exactly three Get commands' {
        @($FirstThree).Count | Should -Be 3 -Because 'Get-Command limits the number of results with -TotalCount'
        @($FirstThree | Where-Object { $_.Name -notlike 'Get-*' }).Count | Should -Be 0
    }

    It 'PatchDate holds the date as text' {
        $PatchDate | Should -Be '14.03.2026' -Because 'Get-Date turns a date into text with -Format'
    }
}
