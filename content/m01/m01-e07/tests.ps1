param($SolutionPath)

Describe 'Documentation for the handover note of FS-02' {
    BeforeAll {
        Mock Get-Process {
            [pscustomobject]@{ Name = 'LanmanServer'; Id = 1432 }
            [pscustomobject]@{ Name = 'dfsrs'; Id = 2876 }
        }
        . $SolutionPath
    }

    It 'Translation resolves all four aliases' {
        (@($Translation).Name | Sort-Object) -join ', ' | Should -Be 'gal, gci, gcm, gps' -Because 'the parameter -Name takes all four aliases, separated by commas'
    }

    It 'Translation shows the cmdlets behind the aliases' {
        (@($Translation).Definition | Sort-Object) -join ', ' | Should -Be 'Get-Alias, Get-ChildItem, Get-Command, Get-Process'
    }

    It 'ItemAliases holds the aliases of Get-ChildItem' {
        @($ItemAliases).Name | Should -Contain 'gci' -Because 'you know the cmdlet and search for its aliases, that is the parameter -Definition'
    }

    It 'ItemAliases holds nothing but aliases of Get-ChildItem' {
        $other = @($ItemAliases | Where-Object { $_.Definition -ne 'Get-ChildItem' }).Name -join ', '
        $other | Should -Be ''
    }

    It 'The alias procs exists and points to Get-Process' {
        $alias = Get-Alias -Name procs -ErrorAction SilentlyContinue
        $alias.Definition | Should -Be 'Get-Process' -Because 'Set-Alias creates the alias with -Name procs and -Value Get-Process'
    }

    It 'FromAlias holds the output of the alias' {
        @($FromAlias).Name -join ', ' | Should -Be 'LanmanServer, dfsrs' -Because 'calling procs runs Get-Process'
    }
}
