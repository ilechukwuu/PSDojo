param($SolutionPath)

Describe 'Check for TS-03' {
    BeforeAll {
        Mock Get-Process {
            $all = @(
                [pscustomobject]@{ Name = 'spoolsv'; Id = 2104 }
                [pscustomobject]@{ Name = 'lsass'; Id = 712 }
                [pscustomobject]@{ Name = 'winword'; Id = 6120 }
            )
            $all | Where-Object { -not $Name -or $Name -contains $_.Name }
        }
        . $SolutionPath 2>$null
        $pipeline = @(Get-Content -LiteralPath $SolutionPath | Where-Object { $_ -match '^\s*\$Running\s*=' })
    }

    It 'Running holds the two processes from the rows' {
        (@($Running).Name | Sort-Object) -join ', ' | Should -Be 'lsass, spoolsv' -Because 'the property must be called Name so that it binds to the parameter -Name'
    }

    It 'The pipeline line itself is unchanged' {
        ($pipeline -join '').Trim() | Should -Be '$Running = $Rows | Get-Process' -Because 'the fix belongs in the data, not in the pipeline'
    }

    It 'Stamp holds the date of today as text' {
        $Stamp | Should -Be (Get-Date -Format 'yyyyMMdd') -Because 'the format text belongs to the parameter -Format, which takes no pipeline input'
    }
}
