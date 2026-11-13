param($SolutionPath)

Describe 'Nightly cleanup with a dry run' {
    BeforeAll {
        $folder = Join-Path -Path $TestDrive -ChildPath 'import'
        $sub = Join-Path -Path $folder -ChildPath 'batch [7]'
        $null = New-Item -Path $sub -ItemType Directory -Force
        $old1 = Join-Path -Path $folder -ChildPath 'orders.tmp'
        $old2 = Join-Path -Path $sub -ChildPath 'items.tmp'
        $new = Join-Path -Path $folder -ChildPath 'running.tmp'
        $other = Join-Path -Path $sub -ChildPath 'import.log'
        foreach ($entry in @(@($old1, 20), @($old2, 10), @($new, 0), @($other, 30))) {
            Set-Content -LiteralPath $entry[0] -Value 'data'
            (Get-Item -LiteralPath $entry[0]).LastWriteTime = (Get-Date).AddDays(-$entry[1])
        }

        . $SolutionPath -Root $folder -WhatIf 2>$null
        $dryCandidates = @($Candidates | Where-Object { $null -ne $_ }).Name | Sort-Object
        $dryOld1 = Test-Path -LiteralPath $old1
        $dryOld2 = Test-Path -LiteralPath $old2

        $Candidates = $null
        . $SolutionPath -Root $folder 2>$null
    }

    It 'Candidates holds the two old temporary files' {
        $dryCandidates -join ', ' | Should -Be 'items.tmp, orders.tmp' -Because 'files with the extension .tmp from all subfolders that are older than 7 days are collected'
    }

    It 'With -WhatIf nothing is deleted' {
        ($dryOld1 -and $dryOld2) | Should -BeTrue -Because 'the script has to hand its switch on to Remove-Item with -WhatIf:$WhatIf. Otherwise a dry run deletes'
    }

    It 'Without -WhatIf the old temporary files are gone' {
        Test-Path -LiteralPath $old1 | Should -BeFalse -Because 'Remove-Item deletes each file in $Candidates'
        Test-Path -LiteralPath $old2 | Should -BeFalse -Because 'files in subfolders are deleted too. -LiteralPath copes with brackets in a folder name'
    }

    It 'Newer and other files stay' {
        Test-Path -LiteralPath $new | Should -BeTrue -Because 'a temporary file written today may still be in use'
        Test-Path -LiteralPath $other | Should -BeTrue -Because 'only .tmp files are deleted'
    }
}
