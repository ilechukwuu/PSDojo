param($SolutionPath)

Describe 'Memory check for TS-03' {
    BeforeAll {
        $ast = [System.Management.Automation.Language.Parser]::ParseFile($SolutionPath, [ref]$null, [ref]$null)
        $commands = $ast.FindAll({ param($node) $node -is [System.Management.Automation.Language.CommandAst] }, $true)
        $usedAliases = @(
            foreach ($command in $commands) {
                $name = $command.GetCommandName()
                if ($name -and (Get-Alias -Name $name -ErrorAction SilentlyContinue)) {
                    $name
                }
            }
        )

        Mock Get-Process {
            [pscustomobject]@{ Name = 'sqlservr'; Id = 1968; WorkingSet64 = 2147483648; Handles = 1210 }
            [pscustomobject]@{ Name = 'spoolsv'; Id = 2104; WorkingSet64 = 15728640; Handles = 420 }
            [pscustomobject]@{ Name = 'MsMpEng'; Id = 3312; WorkingSet64 = 734003200; Handles = 880 }
            [pscustomobject]@{ Name = 'rdpclip'; Id = 5120; WorkingSet64 = 9437184; Handles = 215 }
            [pscustomobject]@{ Name = 'backupagent'; Id = 4410; WorkingSet64 = 524288000; Handles = 301 }
        }
        . $SolutionPath
    }

    It 'Heavy still holds the processes above 500 MB' {
        @($Heavy).Name -join ', ' | Should -Be 'sqlservr, MsMpEng' -Because 'the behavior of the script must not change'
    }

    It 'Heavy still has only the properties Name, Id and WorkingSet64' {
        @($Heavy)[0].PSObject.Properties.Name -join ', ' | Should -Be 'Name, Id, WorkingSet64' -Because 'the behavior of the script must not change'
    }

    It 'Names still holds the process names' {
        @($Names) -join ', ' | Should -Be 'sqlservr, MsMpEng' -Because 'the behavior of the script must not change'
    }

    It 'The script contains no alias' {
        $usedAliases -join ', ' | Should -Be '' -Because 'a script uses full cmdlet names. Get-Alias -Name shows the cmdlet behind an alias'
    }
}
