param($SolutionPath)

Describe 'Watch lists for TS-03' {
    BeforeAll {
        Mock Get-Process {
            $all = @(
                [pscustomobject]@{ Name = 'spoolsv'; Id = 2104 }
                [pscustomobject]@{ Name = 'lsass'; Id = 712 }
                [pscustomobject]@{ Name = 'rdpclip'; Id = 5120 }
                [pscustomobject]@{ Name = 'backupagent'; Id = 4410 }
                [pscustomobject]@{ Name = 'winword'; Id = 6120 }
            )
            $all | Where-Object { -not $Name -or $Name -contains $_.Name }
        }
        . $SolutionPath
    }

    It 'Running holds the processes of the watch list' {
        (@($Running).Name | Sort-Object) -join ', ' | Should -Be 'lsass, spoolsv' -Because 'the property Name of each row binds to the parameter -Name'
    }

    It 'Legacy holds the processes of the legacy list' {
        (@($Legacy).Name | Sort-Object) -join ', ' | Should -Be 'backupagent, rdpclip' -Because 'the legacy list must be piped in. Its property ProcessName matches an alias of -Name'
    }

    It 'The rows became aliases' {
        $procs = Get-Alias -Name procs -ErrorAction SilentlyContinue
        $items = Get-Alias -Name items -ErrorAction SilentlyContinue
        $procs.Definition | Should -Be 'Get-Process' -Because 'the properties Name and Value of each row bind to -Name and -Value of New-Alias'
        $items.Definition | Should -Be 'Get-ChildItem'
    }
}
