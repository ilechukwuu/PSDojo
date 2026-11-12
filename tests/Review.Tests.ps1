BeforeAll {
    . (Join-Path -Path $PSScriptRoot -ChildPath 'TestHelpers.ps1')
    Import-DojoModuleForTest
    $savedContent = $env:PSDOJO_CONTENT
    $savedHome = $env:PSDOJO_HOME

    function Get-MetaFile {
        param($Id)
        return (Join-Path -Path $env:PSDOJO_CONTENT -ChildPath "m01/$Id/meta.json")
    }

    function Get-Meta {
        param($Id)
        return (Get-Content -LiteralPath (Get-MetaFile -Id $Id) -Raw -Encoding UTF8 | ConvertFrom-Json)
    }

    function Get-LearnerIds {
        return @(Invoke-DojoPrivate -ScriptBlock { Get-DojoExerciseList }).Id
    }
}

AfterAll {
    $env:PSDOJO_CONTENT = $savedContent
    $env:PSDOJO_HOME = $savedHome
}

Describe 'Review workflow' {
    BeforeAll {
        $env:PSDOJO_CONTENT = New-DojoTestContent -Destination (Join-Path -Path $TestDrive -ChildPath 'content')
        $env:PSDOJO_HOME = Join-Path -Path $TestDrive -ChildPath 'home'
        $null = Get-DojoHostText -ScriptBlock { Start-Dojo -Language en }
    }

    Context 'Listing' {
        It 'lists every draft' {
            $items = @(Get-DojoReviewItem)
            $items.Count | Should -Be 8
            ($items.Status | Sort-Object -Unique) | Should -Be 'draft'
        }

        It 'filters by status and module' {
            @(Get-DojoReviewItem -Status approved).Count | Should -Be 0
            @(Get-DojoReviewItem -Module 'm01').Count | Should -Be 8
            @(Get-DojoReviewItem -Module 'm99').Count | Should -Be 0
        }

        It 'renders as one table' {
            $text = Get-DojoReviewItem | Out-String -Width 160
            $text | Should -Match 'Id\s+Type\s+Status\s+LastAction\s+Reviewer\s+Timestamp\s+Title'
        }
    }

    Context 'Showing one exercise' {
        BeforeAll {
            $text = Get-DojoHostText -ScriptBlock { Show-DojoReviewItem -Id 'm01-e06' }
        }

        It 'shows the lesson and the task in both languages' {
            $text | Should -Match 'lesson\.de\.md'
            $text | Should -Match 'Ein Alias ist ein zweiter'
            $text | Should -Match 'lesson\.en\.md'
            $text | Should -Match 'An alias is a second'
            $text | Should -Match 'task\.de\.md'
            $text | Should -Match 'task\.en\.md'
        }

        It 'shows hints, starter, solution, wrong answer and tests' {
            $text | Should -Match 'hints\.json'
            $text | Should -Match 'starter\.ps1'
            $text | Should -Match 'solution\.ps1'
            $text | Should -Match 'Select-Object -Property Name, Id, WorkingSet64'
            $text | Should -Match 'wrong\.ps1'
            $text | Should -Match 'tests\.ps1'
            $text | Should -Match 'The script contains no alias'
        }

        It 'verifies starter, solution and wrong answer for the reviewer' {
            $text | Should -Match 'ok\s+contract'
            $text | Should -Match 'ok\s+starter\.ps1'
            $text | Should -Match 'ok\s+solution\.ps1\s+Passed, 4 of 4'
            $text | Should -Match 'ok\s+wrong\.ps1'
            $text | Should -Not -MatchExactly 'FAIL '
        }

        It 'can be limited to one language' {
            $english = Get-DojoHostText -ScriptBlock { Show-DojoReviewItem -Id 'm01-e06' -Language en -SkipVerification }
            $english | Should -Not -Match 'Ein Alias ist ein zweiter'
            $english | Should -Not -Match '=== verification'
        }

        It 'marks the right answers of a quiz for the reviewer' {
            $quiz = Get-DojoHostText -ScriptBlock { Show-DojoReviewItem -Id 'm01-e08' -Language en -SkipVerification }
            $quiz | Should -Match '\*c\) Which action is performed'
        }

        It 'reports an unknown id as an error' {
            { Show-DojoReviewItem -Id 'm01-e99' -ErrorAction Stop } | Should -Throw '*not found*'
        }
    }

    Context 'Approving' {
        It 'changes nothing with -WhatIf' {
            $before = Get-Content -LiteralPath (Get-MetaFile -Id 'm01-e01') -Raw
            $null = Get-DojoHostText -ScriptBlock { Approve-DojoExercise -Id 'm01-e01' -Reviewer 'j.brandt' -WhatIf }
            Get-Content -LiteralPath (Get-MetaFile -Id 'm01-e01') -Raw | Should -Be $before
        }

        It 'moves a draft to reviewed and records reviewer, timestamp and comment' {
            $null = Get-DojoHostText -ScriptBlock { Approve-DojoExercise -Id 'm01-e01' -Reviewer 'j.brandt' -Comment 'German checked' }
            $meta = Get-Meta -Id 'm01-e01'
            $meta.status | Should -Be 'reviewed'
            $meta.review.reviewer | Should -Be 'j.brandt'
            $meta.review.comment | Should -Be 'German checked'
            $meta.review.action | Should -Be 'approve'
            $meta.review.from | Should -Be 'draft'
            $meta.review.to | Should -Be 'reviewed'
            ([datetime]::UtcNow - ([datetime]$meta.review.timestamp).ToUniversalTime()).TotalMinutes | Should -BeLessThan 5
        }

        It 'does not show a reviewed exercise to a learner' {
            Get-LearnerIds | Should -Not -Contain 'm01-e01'
        }

        It 'refuses the second approval by the same reviewer' {
            { Approve-DojoExercise -Id 'm01-e01' -Reviewer 'j.brandt' -ErrorAction Stop } | Should -Throw '*different reviewer*'
            (Get-Meta -Id 'm01-e01').status | Should -Be 'reviewed'
        }

        It 'moves reviewed to approved with a second reviewer' {
            $null = Get-DojoHostText -ScriptBlock { Approve-DojoExercise -Id 'm01-e01' -Reviewer 's.oezdemir' }
            $meta = Get-Meta -Id 'm01-e01'
            $meta.status | Should -Be 'approved'
            $meta.review.reviewer | Should -Be 's.oezdemir'
            @($meta.reviewHistory).Count | Should -Be 2
        }

        It 'shows the approved exercise to a learner' {
            Get-LearnerIds | Should -Be 'm01-e01'
            $text = Get-DojoHostText -ScriptBlock { Start-Dojo }
            $text | Should -Match 'm01-e01'
        }

        It 'refuses to approve what is already approved' {
            { Approve-DojoExercise -Id 'm01-e01' -Reviewer 'k.weiss' -ErrorAction Stop } | Should -Throw '*already approved*'
        }

        It 'allows one person to do both steps only with -AllowSameReviewer' {
            $null = Get-DojoHostText -ScriptBlock {
                Approve-DojoExercise -Id 'm01-e02' -Reviewer 'j.brandt'
                Approve-DojoExercise -Id 'm01-e02' -Reviewer 'j.brandt' -AllowSameReviewer
            }
            (Get-Meta -Id 'm01-e02').status | Should -Be 'approved'
        }

        It 'keeps meta.json valid, ordered and with its umlauts' {
            $problems = @(Invoke-DojoPrivate -ScriptBlock { param($p) Test-DojoExerciseFolder -Path $p } -ArgumentList (Split-Path -Path (Get-MetaFile -Id 'm01-e02') -Parent))
            $problems -join '; ' | Should -Be ''
            $text = Get-Content -LiteralPath (Get-MetaFile -Id 'm01-e02') -Raw -Encoding UTF8
            $text | Should -Match '(?s)^\{\s+"id": "m01-e02",\s+"module": "m01",\s+"title": \{'
            $text | Should -Match '"prerequisites": \["m01-e01"\]'
            $text | Should -Match ('ausschlie' + [char]0xDF + 'lich')
            [System.IO.File]::ReadAllBytes((Get-MetaFile -Id 'm01-e02'))[0] | Should -Be 123
        }
    }

    Context 'Quality gate on approval' {
        It 'refuses an exercise whose solution fails' {
            $file = Join-Path -Path $env:PSDOJO_CONTENT -ChildPath 'm01/m01-e03/solution.ps1'
            $original = Get-Content -LiteralPath $file -Raw
            Set-Content -LiteralPath $file -Value '$ProcessCommands = $null'
            { Approve-DojoExercise -Id 'm01-e03' -Reviewer 'j.brandt' -ErrorAction Stop } | Should -Throw '*solution.ps1*'
            (Get-Meta -Id 'm01-e03').status | Should -Be 'draft'
            Set-Content -LiteralPath $file -Value $original -NoNewline
        }

        It 'refuses an exercise whose wrong answer passes' {
            $folder = Join-Path -Path $env:PSDOJO_CONTENT -ChildPath 'm01/m01-e03'
            $original = Get-Content -LiteralPath (Join-Path -Path $folder -ChildPath 'wrong.ps1') -Raw
            Copy-Item -LiteralPath (Join-Path -Path $folder -ChildPath 'solution.ps1') -Destination (Join-Path -Path $folder -ChildPath 'wrong.ps1') -Force
            { Approve-DojoExercise -Id 'm01-e03' -Reviewer 'j.brandt' -ErrorAction Stop } | Should -Throw '*wrong.ps1*'
            Set-Content -LiteralPath (Join-Path -Path $folder -ChildPath 'wrong.ps1') -Value $original -NoNewline
        }

        It 'refuses an exercise whose starter already passes' {
            $folder = Join-Path -Path $env:PSDOJO_CONTENT -ChildPath 'm01/m01-e03'
            $original = Get-Content -LiteralPath (Join-Path -Path $folder -ChildPath 'starter.ps1') -Raw
            Copy-Item -LiteralPath (Join-Path -Path $folder -ChildPath 'solution.ps1') -Destination (Join-Path -Path $folder -ChildPath 'starter.ps1') -Force
            { Approve-DojoExercise -Id 'm01-e03' -Reviewer 'j.brandt' -ErrorAction Stop } | Should -Throw '*starter.ps1*'
            Set-Content -LiteralPath (Join-Path -Path $folder -ChildPath 'starter.ps1') -Value $original -NoNewline
        }

        It 'approves the same exercise once it is intact again' {
            $null = Get-DojoHostText -ScriptBlock { Approve-DojoExercise -Id 'm01-e03' -Reviewer 'j.brandt' }
            (Get-Meta -Id 'm01-e03').status | Should -Be 'reviewed'
        }
    }

    Context 'Rejecting' {
        It 'needs a comment' {
            { Deny-DojoExercise -Id 'm01-e01' -Comment '' -Reviewer 'k.weiss' -ErrorAction Stop } | Should -Throw
            { Deny-DojoExercise -Id 'm01-e01' -Comment '   ' -Reviewer 'k.weiss' -ErrorAction Stop } | Should -Throw '*comment*'
            (Get-Meta -Id 'm01-e01').status | Should -Be 'approved'
        }

        It 'changes nothing with -WhatIf' {
            $null = Get-DojoHostText -ScriptBlock { Deny-DojoExercise -Id 'm01-e01' -Comment 'test' -Reviewer 'k.weiss' -WhatIf }
            (Get-Meta -Id 'm01-e01').status | Should -Be 'approved'
        }

        It 'sends an approved exercise back to draft and records who, when and why' {
            $null = Get-DojoHostText -ScriptBlock { Deny-DojoExercise -Id 'm01-e01' -Comment 'Hint 3 gives the answer away' -Reviewer 'k.weiss' }
            $meta = Get-Meta -Id 'm01-e01'
            $meta.status | Should -Be 'draft'
            $meta.review.action | Should -Be 'reject'
            $meta.review.reviewer | Should -Be 'k.weiss'
            $meta.review.comment | Should -Be 'Hint 3 gives the answer away'
            $meta.review.timestamp | Should -Not -BeNullOrEmpty
            @($meta.reviewHistory).Count | Should -Be 3
            @($meta.reviewHistory)[0].reviewer | Should -Be 'j.brandt'
        }

        It 'hides the rejected exercise from the learner again' {
            Get-LearnerIds | Should -Not -Contain 'm01-e01'
            $text = Get-DojoHostText -ScriptBlock { Test-Dojo -Id 'm01-e01' }
            $text | Should -Match 'does not exist or is not released'
        }

        It 'sends a reviewed exercise back to draft' {
            $null = Get-DojoHostText -ScriptBlock { Deny-DojoExercise -Id 'm01-e03' -Comment 'Task 3 is unclear' -Reviewer 'k.weiss' }
            (Get-Meta -Id 'm01-e03').status | Should -Be 'draft'
        }

        It 'shows the history and the comment in the review view and the list' {
            $text = Get-DojoHostText -ScriptBlock { Show-DojoReviewItem -Id 'm01-e01' -Language en -SkipVerification }
            $text | Should -Match 'approve\s+draft -> reviewed\s+j\.brandt\s+German checked'
            $text | Should -Match 'reject\s+approved -> draft\s+k\.weiss\s+Hint 3 gives the answer away'
            $item = Get-DojoReviewItem | Where-Object { $_.Id -eq 'm01-e01' }
            $item.LastAction | Should -Be 'reject'
            $item.Comment | Should -Be 'Hint 3 gives the answer away'
        }
    }
}

Describe 'Exercises that are not available on this machine' {
    BeforeAll {
        $env:PSDOJO_CONTENT = New-DojoTestContent -Destination (Join-Path -Path $TestDrive -ChildPath 'content2') -ApproveAll
        Set-DojoTestMeta -ContentRoot $env:PSDOJO_CONTENT -Id 'm01-e02' -Values @{ minPowerShell = '99.0' }
        Set-DojoTestMeta -ContentRoot $env:PSDOJO_CONTENT -Id 'm01-e03' -Values @{ requires = @('psdojo-missing-tool') }
        Set-DojoTestMeta -ContentRoot $env:PSDOJO_CONTENT -Id 'm01-e04' -Values @{ minPowerShell = '5.1'; requires = @('Get-Command') }
        $env:PSDOJO_HOME = Join-Path -Path $TestDrive -ChildPath 'home2'
        $null = Get-DojoHostText -ScriptBlock { Start-Dojo -Language en }
        Copy-Item -LiteralPath (Join-Path -Path $env:PSDOJO_CONTENT -ChildPath 'm01/m01-e01/solution.ps1') -Destination (Join-Path -Path $env:PSDOJO_HOME -ChildPath 'm01/m01-e01.ps1') -Force
        $passText = Get-DojoHostText -ScriptBlock { Test-Dojo }
    }

    It 'skips them when it picks the next exercise' {
        $passText | Should -Match 'PASSED'
        $passText | Should -Match 'Next\s*: m01-e04'
    }

    It 'marks them in the module map with the reason' {
        $text = Get-DojoHostText -ScriptBlock { Show-DojoProgress }
        $text | Should -Match '\[!\] m01-e02.*needs PowerShell 99\.0 or newer'
        $text | Should -Match '\[!\] m01-e03.*needs the command psdojo-missing-tool'
        $text | Should -Match '\[>\] m01-e04'
    }

    It 'refuses to check them and counts no attempt' {
        $text = Get-DojoHostText -ScriptBlock { Test-Dojo -Id 'm01-e02' }
        $text | Should -Match 'not available on this machine'
        $rows = @(Show-DojoProgress -PassThru)
        ($rows | Where-Object { $_.Id -eq 'm01-e02' }).State | Should -Be 'unavailable'
        ($rows | Where-Object { $_.Id -eq 'm01-e02' }).Attempts | Should -Be 0
    }

    It 'refuses to approve them on a host that cannot verify them' {
        Set-DojoTestMeta -ContentRoot $env:PSDOJO_CONTENT -Id 'm01-e02' -Values @{ status = 'draft' }
        { Approve-DojoExercise -Id 'm01-e02' -Reviewer 'j.brandt' -ErrorAction Stop } | Should -Throw '*needs PowerShell 99.0*'
    }

    It 'rejects a minPowerShell value that is not a version' {
        Set-DojoTestMeta -ContentRoot $env:PSDOJO_CONTENT -Id 'm01-e05' -Values @{ minPowerShell = 'seven' }
        $problems = @(Invoke-DojoPrivate -ScriptBlock { param($p) Test-DojoExerciseFolder -Path $p } -ArgumentList (Join-Path -Path $env:PSDOJO_CONTENT -ChildPath 'm01/m01-e05'))
        $problems -join '; ' | Should -Match 'minPowerShell'
    }
}

Describe 'Capstone modules' {
    It 'are loaded with their kind' {
        $env:PSDOJO_CONTENT = New-DojoTestContent -Destination (Join-Path -Path $TestDrive -ChildPath 'content3')
        $file = Join-Path -Path $env:PSDOJO_CONTENT -ChildPath 'm01/module.json'
        (Get-Content -LiteralPath $file -Raw -Encoding UTF8) -replace '"part": 1', '"kind": "capstone", "part": 4' | Set-Content -LiteralPath $file -Encoding UTF8
        $module = @(Invoke-DojoPrivate -ScriptBlock { Get-DojoModuleList })[0]
        $module.Kind | Should -Be 'capstone'
        $module.Part | Should -Be 4
    }

    It 'default to the kind standard' {
        $env:PSDOJO_CONTENT = Join-Path -Path (Get-DojoRepoRoot) -ChildPath 'content'
        @(Invoke-DojoPrivate -ScriptBlock { Get-DojoModuleList })[0].Kind | Should -Be 'standard'
        @(Invoke-DojoPrivate -ScriptBlock { Get-DojoModuleList })[0].Track | Should -Be 'core'
    }
}
