BeforeAll {
    . (Join-Path -Path $PSScriptRoot -ChildPath 'TestHelpers.ps1')
    Import-DojoModuleForTest
    $savedContent = $env:PSDOJO_CONTENT
    $savedHome = $env:PSDOJO_HOME
}

AfterAll {
    $env:PSDOJO_CONTENT = $savedContent
    $env:PSDOJO_HOME = $savedHome
}

Describe 'Draft and reviewed exercises never reach a learner' {
    BeforeAll {
        $content = New-DojoTestContent -Destination (Join-Path -Path $TestDrive -ChildPath 'content') -Approved 'm01-e01', 'm01-e04' -Reviewed 'm01-e02'
        $env:PSDOJO_CONTENT = $content
        $env:PSDOJO_HOME = Join-Path -Path $TestDrive -ChildPath 'home'
        $startText = Get-DojoHostText -ScriptBlock { Start-Dojo -Language en }
        $hidden = 'm01-e02', 'm01-e03', 'm01-e05', 'm01-e06', 'm01-e07', 'm01-e08'
    }

    It 'the loader returns approved exercises only' {
        $ids = @(Invoke-DojoPrivate -ScriptBlock { Get-DojoExerciseList }).Id
        $ids -join ', ' | Should -Be 'm01-e01, m01-e04'
    }

    It 'Start-Dojo copies starter files for approved exercises only' {
        $files = @(Get-ChildItem -LiteralPath $env:PSDOJO_HOME -Filter '*.ps1' -Recurse).Name | Sort-Object
        $files -join ', ' | Should -Be 'm01-e01.ps1, m01-e04.ps1'
        $startText | Should -Match '2 exercises'
    }

    It 'Show-DojoProgress does not list <_>' -ForEach @('m01-e02', 'm01-e03', 'm01-e05', 'm01-e06', 'm01-e07', 'm01-e08') {
        $text = Get-DojoHostText -ScriptBlock { Show-DojoProgress }
        $text | Should -Not -Match $_
        @(Show-DojoProgress -PassThru).Id | Should -Not -Contain $_
    }

    It 'Show-DojoLesson refuses <_>' -ForEach @('m01-e02', 'm01-e03') {
        $text = Get-DojoHostText -ScriptBlock { Show-DojoLesson -Id $_ }
        $text | Should -Match 'does not exist or is not released'
        $text | Should -Not -Match 'Verb-Noun|Get-Command finds'
    }

    It 'Test-Dojo refuses <_>' -ForEach @('m01-e02', 'm01-e03') {
        $text = Get-DojoHostText -ScriptBlock { Test-Dojo -Id $_ }
        $text | Should -Match 'does not exist or is not released'
    }

    It 'Get-DojoHint refuses <_> and never shows its solution' -ForEach @('m01-e02', 'm01-e03') {
        $text = Get-DojoHostText -ScriptBlock { Get-DojoHint -Id $_; Get-DojoHint -Id $_ -Solution }
        $text | Should -Match 'does not exist or is not released'
        $text | Should -Not -Match 'Restart-Service|Get-Command -Noun'
    }

    It 'Reset-DojoExercise and Start-Dojo -Id refuse <_>' -ForEach @('m01-e02', 'm01-e03') {
        $text = Get-DojoHostText -ScriptBlock { Reset-DojoExercise -Id $_; Start-Dojo -Id $_ }
        ([regex]::Matches($text, 'does not exist or is not released')).Count | Should -Be 2
        @(Get-ChildItem -LiteralPath $env:PSDOJO_HOME -Filter "$_.ps1" -Recurse).Count | Should -Be 0
    }

    It 'the exported report contains approved exercises only' {
        $file = $null
        $file = Export-DojoReport 6>$null
        $data = Get-Content -LiteralPath $file.FullName -Raw -Encoding UTF8 | ConvertFrom-Json
        @($data.exercises).id -join ', ' | Should -Be 'm01-e01, m01-e04'
    }

    It 'an unapproved prerequisite does not lock an approved exercise' {
        Copy-Item -LiteralPath (Join-Path -Path $content -ChildPath 'm01/m01-e01/solution.ps1') -Destination (Join-Path -Path $env:PSDOJO_HOME -ChildPath 'm01/m01-e01.ps1') -Force
        $text = Get-DojoHostText -ScriptBlock { Test-Dojo }
        $text | Should -Match 'PASSED'
        $text | Should -Match 'm01-e04'
        ($hidden | Where-Object { $text -match $_ }) | Should -BeNullOrEmpty
    }
}

Describe 'Everything in the repository starts as draft' {
    BeforeAll {
        $env:PSDOJO_CONTENT = Join-Path -Path (Get-DojoRepoRoot) -ChildPath 'content'
        $env:PSDOJO_HOME = Join-Path -Path $TestDrive -ChildPath 'home-real'
    }

    It 'a learner sees only what a reviewer approved' {
        $all = @(Invoke-DojoPrivate -ScriptBlock { Get-DojoExerciseList -IncludeUnapproved })
        $approved = @($all | Where-Object { $_.Status -eq 'approved' }).Id
        $visible = @(Invoke-DojoPrivate -ScriptBlock { Get-DojoExerciseList }).Id
        $visible -join ', ' | Should -Be ($approved -join ', ')
        $null = Get-DojoHostText -ScriptBlock { Start-Dojo -Language en }
        $files = @()
        if (Test-Path -LiteralPath $env:PSDOJO_HOME) {
            $files = @(Get-ChildItem -LiteralPath $env:PSDOJO_HOME -Filter '*.ps1' -Recurse)
        }
        $files.Count | Should -Be $approved.Count
    }
}
