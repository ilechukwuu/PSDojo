BeforeAll {
    . (Join-Path -Path $PSScriptRoot -ChildPath 'TestHelpers.ps1')
    Import-DojoModuleForTest
    $savedContent = $env:PSDOJO_CONTENT
    $savedHome = $env:PSDOJO_HOME
    $content = New-DojoTestContent -Destination (Join-Path -Path $TestDrive -ChildPath 'content') -ApproveAll
    $env:PSDOJO_CONTENT = $content

    function New-DojoTestHome {
        param($Name)
        $path = Join-Path -Path $TestDrive -ChildPath $Name
        $env:PSDOJO_HOME = $path
        Invoke-DojoPrivate -ScriptBlock { $script:DojoLanguageOverride = $null }
        $null = Get-DojoHostText -ScriptBlock { Start-Dojo -Language en }
        return $path
    }

    function Copy-DojoAnswer {
        param($Id, $Kind)
        $source = Join-Path -Path (Join-Path -Path (Join-Path -Path $content -ChildPath 'm01') -ChildPath $Id) -ChildPath "$Kind.ps1"
        $target = Join-Path -Path (Join-Path -Path $env:PSDOJO_HOME -ChildPath 'm01') -ChildPath "$Id.ps1"
        Copy-Item -LiteralPath $source -Destination $target -Force
    }

    function Get-DojoProgressFile {
        return (Get-Content -LiteralPath (Join-Path -Path $env:PSDOJO_HOME -ChildPath 'progress.json') -Raw -Encoding UTF8 | ConvertFrom-Json)
    }
}

AfterAll {
    $env:PSDOJO_CONTENT = $savedContent
    $env:PSDOJO_HOME = $savedHome
}

Describe 'Module import' {
    It 'exports exactly the documented commands' {
        $expected = 'Export-DojoReport', 'Get-DojoHint', 'Get-DojoTeamReport', 'Reset-DojoExercise', 'Set-DojoLanguage', 'Show-DojoLesson', 'Show-DojoProgress', 'Start-Dojo', 'Test-Dojo'
        ((Get-Command -Module PSDojo).Name | Sort-Object) -join ', ' | Should -Be ($expected -join ', ')
    }

    It 'fails with a clear install message when Pester 5 is missing' {
        $shell = (Get-Process -Id $PID).Path
        $manifest = Join-Path -Path (Get-DojoRepoRoot) -ChildPath 'module/PSDojo/PSDojo.psd1'
        $empty = Join-Path -Path $TestDrive -ChildPath 'nomodules'
        $null = New-Item -Path $empty -ItemType Directory -Force
        $command = "`$env:PSModulePath = '$empty'; try { Import-Module -Name '$manifest' -ErrorAction Stop; 'IMPORTED' } catch { `$_.Exception.Message }"
        $output = (& $shell -NoProfile -NonInteractive -Command $command | Out-String)
        $output | Should -Not -Match 'IMPORTED'
        $output | Should -Match 'Install-Module -Name Pester -MinimumVersion'
    }
}

Describe 'Start-Dojo' {
    BeforeAll {
        $dojoHome = New-DojoTestHome -Name 'start'
    }

    It 'copies one starter file per exercise into the learner folder' {
        @(Get-ChildItem -LiteralPath (Join-Path -Path $dojoHome -ChildPath 'm01') -Filter '*.ps1').Count | Should -Be 8
    }

    It 'stores progress as JSON in the learner folder' {
        $progress = Get-DojoProgressFile
        $progress.current | Should -Be 'm01-e01'
        $progress.language | Should -Be 'en'
    }

    It 'shows the next open exercise' {
        $text = Get-DojoHostText -ScriptBlock { Start-Dojo }
        $text | Should -Match 'm01-e01'
        $text | Should -Match 'Morning check'
    }

    It 'never overwrites the work of the learner' {
        $file = Join-Path -Path (Join-Path -Path $dojoHome -ChildPath 'm01') -ChildPath 'm01-e01.ps1'
        Set-Content -LiteralPath $file -Value '# my work'
        $null = Get-DojoHostText -ScriptBlock { Start-Dojo }
        (Get-Content -LiteralPath $file -Raw).Trim() | Should -Be '# my work'
    }

    It 'refuses to jump to a locked exercise' {
        $text = Get-DojoHostText -ScriptBlock { Start-Dojo -Id 'm01-e05' }
        $text | Should -Match 'locked'
        (Get-DojoProgressFile).current | Should -Be 'm01-e01'
    }
}

Describe 'Show-DojoLesson' {
    BeforeAll {
        $dojoHome = New-DojoTestHome -Name 'lesson'
    }

    It 'prints lesson and task as plain text without markdown markers' {
        $text = Get-DojoHostText -ScriptBlock { Show-DojoLesson }
        $text | Should -Match 'Cmdlets do the work'
        $text | Should -Match 'print server PRN-01'
        $text | Should -Not -Match '```'
        $text | Should -Not -Match '(?m)^#'
        $text | Should -Not -Match '\x1b\['
    }

    It 'prints German after the language is switched' {
        $null = Get-DojoHostText -ScriptBlock { Set-DojoLanguage -Language de }
        $text = Get-DojoHostText -ScriptBlock { Show-DojoLesson }
        $text | Should -Match 'Cmdlets erledigen die Arbeit'
        $text | Should -Match 'Aufgabe'
        $null = Get-DojoHostText -ScriptBlock { Set-DojoLanguage -Language en }
    }

    It 'prints the questions of a quiz' {
        $text = Get-DojoHostText -ScriptBlock { Invoke-DojoPrivate -ScriptBlock {
                $progress = Read-DojoProgress
                foreach ($id in 'm01-e01', 'm01-e02', 'm01-e03', 'm01-e04', 'm01-e05', 'm01-e06', 'm01-e07') {
                    (Get-DojoExerciseRecord -Progress $progress -Id $id)['status'] = 'completed'
                }
                Save-DojoProgress -Progress $progress
            }
            Show-DojoLesson -Id 'm01-e08' }
        $text | Should -Match '10\. '
        $text | Should -Match '   d\) '
    }
}

Describe 'Test-Dojo' {
    BeforeAll {
        $dojoHome = New-DojoTestHome -Name 'test'
    }

    It 'fails the untouched starter and shows expected value, actual value and concept' {
        $text = Get-DojoHostText -ScriptBlock { Test-Dojo }
        $text | Should -Match 'NOT YET'
        $text | Should -Match 'Expected\s*: '
        $text | Should -Match 'Actual\s*: '
        $text | Should -Match 'Concept\s*: Cmdlets return objects'
    }

    It 'counts the attempt' {
        (Get-DojoProgressFile).exercises.'m01-e01'.attempts | Should -Be 1
    }

    It 'stops at the first failure' {
        $result = $null
        $result = Test-Dojo -PassThru 6>$null
        $result.TestName | Should -Be 'CheckTime holds a date object'
        $result.PassedCount | Should -Be 0
    }

    It 'never shows a stack trace' {
        Copy-DojoAnswer -Id 'm01-e01' -Kind 'wrong'
        $text = Get-DojoHostText -ScriptBlock { Test-Dojo }
        $text | Should -Not -Match 'at <ScriptBlock>|Pester\.psm1|tests\.ps1|ScriptStackTrace'
    }

    It 'reports a syntax error with its line instead of running the tests' {
        $file = Join-Path -Path (Join-Path -Path $dojoHome -ChildPath 'm01') -ChildPath 'm01-e01.ps1'
        Set-Content -LiteralPath $file -Value @('$CheckTime = Get-Date', '$Processes = Get-Process | Where-Object {')
        $result = $null
        $result = Test-Dojo -PassThru 6>$null
        $text = Get-DojoHostText -ScriptBlock { Test-Dojo }
        $result.Kind | Should -Be 'SyntaxError'
        $result.Line | Should -Be 2
        $text | Should -Match 'Line\s*: 2'
    }

    It 'stops an endless loop and says so' {
        $file = Join-Path -Path (Join-Path -Path $dojoHome -ChildPath 'm01') -ChildPath 'm01-e01.ps1'
        Set-Content -LiteralPath $file -Value 'while ($true) { $CheckTime = Get-Date }'
        Invoke-DojoPrivate -ScriptBlock { $script:CheckTimeoutSeconds = 6 }
        $result = $null
        $result = Test-Dojo -PassThru 6>$null
        $text = Get-DojoHostText -ScriptBlock { Test-Dojo }
        Invoke-DojoPrivate -ScriptBlock { $script:CheckTimeoutSeconds = 60 }
        $result.Kind | Should -Be 'Timeout'
        $text | Should -Match 'endless loop'
    }

    It 'reports a missing learner file' {
        $file = Join-Path -Path (Join-Path -Path $dojoHome -ChildPath 'm01') -ChildPath 'm01-e01.ps1'
        Remove-Item -LiteralPath $file
        $text = Get-DojoHostText -ScriptBlock { Test-Dojo }
        $text | Should -Match 'Reset-DojoExercise'
    }

    It 'restores the starter with Reset-DojoExercise and honors -WhatIf' {
        $file = Join-Path -Path (Join-Path -Path $dojoHome -ChildPath 'm01') -ChildPath 'm01-e01.ps1'
        $null = Get-DojoHostText -ScriptBlock { Reset-DojoExercise -WhatIf }
        $file | Should -Not -Exist
        $null = Get-DojoHostText -ScriptBlock { Reset-DojoExercise }
        (Get-Content -LiteralPath $file -Raw) | Should -Match 'Replace each \$null'
    }

    It 'passes the reference solution, records completion and moves to the next exercise' {
        Copy-DojoAnswer -Id 'm01-e01' -Kind 'solution'
        $text = Get-DojoHostText -ScriptBlock { Test-Dojo }
        $text | Should -Match 'PASSED'
        $text | Should -Match 'm01-e02'
        $progress = Get-DojoProgressFile
        $progress.exercises.'m01-e01'.status | Should -Be 'completed'
        $progress.exercises.'m01-e01'.completedAt | Should -Not -BeNullOrEmpty
        $progress.current | Should -Be 'm01-e02'
    }

    It 'does not count attempts on an exercise that is already completed' {
        $before = (Get-DojoProgressFile).exercises.'m01-e01'.attempts
        $null = Get-DojoHostText -ScriptBlock { Test-Dojo -Id 'm01-e01' }
        (Get-DojoProgressFile).exercises.'m01-e01'.attempts | Should -Be $before
    }

    It 'refuses a locked exercise without counting an attempt' {
        $text = Get-DojoHostText -ScriptBlock { Test-Dojo -Id 'm01-e04' }
        $text | Should -Match 'locked'
        (Get-DojoProgressFile).exercises.'m01-e04' | Should -BeNullOrEmpty
    }

    It 'points to the line when the learner script throws' {
        Invoke-DojoPrivate -ScriptBlock {
            $progress = Read-DojoProgress
            foreach ($id in 'm01-e02', 'm01-e03') {
                (Get-DojoExerciseRecord -Progress $progress -Id $id)['status'] = 'completed'
            }
            Save-DojoProgress -Progress $progress
        }
        $text = Get-DojoHostText -ScriptBlock { Test-Dojo -Id 'm01-e04' }
        $text | Should -Match 'Line\s*: 4'
        $text | Should -Match 'Get-Procces'
    }
}

Describe 'Get-DojoHint' {
    BeforeAll {
        $dojoHome = New-DojoTestHome -Name 'hint'
    }

    It 'keeps the reference solution locked before the third hint' {
        $text = Get-DojoHostText -ScriptBlock { Get-DojoHint -Solution }
        $text | Should -Match 'unlocks after the third hint'
        $text | Should -Not -Match '\$CheckTime = Get-Date'
        (Get-DojoProgressFile).exercises.'m01-e01'.solutionViewed | Should -BeFalse
    }

    It 'gives hint level <_> on call <_>' -ForEach @(1, 2, 3) {
        $text = Get-DojoHostText -ScriptBlock { Get-DojoHint }
        $text | Should -Match "Hint $_/3"
        (Get-DojoProgressFile).exercises.'m01-e01'.hints | Should -Be $_
    }

    It 'still keeps the solution locked after two hints only' {
        $env:PSDOJO_HOME = Join-Path -Path $TestDrive -ChildPath 'hint2'
        $null = Get-DojoHostText -ScriptBlock { Start-Dojo -Language en; Get-DojoHint; Get-DojoHint }
        $text = Get-DojoHostText -ScriptBlock { Get-DojoHint -Solution }
        $text | Should -Match 'unlocks after the third hint'
        $env:PSDOJO_HOME = $dojoHome
    }

    It 'shows the reference solution after the third hint and records it' {
        $text = Get-DojoHostText -ScriptBlock { Get-DojoHint -Solution }
        $text | Should -Match '\$CheckTime = Get-Date'
        $text | Should -Match 'recorded'
        (Get-DojoProgressFile).exercises.'m01-e01'.solutionViewed | Should -BeTrue
    }

    It 'does not count more than three hints' {
        $null = Get-DojoHostText -ScriptBlock { Get-DojoHint }
        (Get-DojoProgressFile).exercises.'m01-e01'.hints | Should -Be 3
    }
}

Describe 'A complete learner session' {
    BeforeAll {
        $dojoHome = New-DojoTestHome -Name 'session'
        $ids = 1..8 | ForEach-Object { 'm01-e0{0}' -f $_ }
        $texts = @{}
        foreach ($id in $ids) {
            Copy-DojoAnswer -Id $id -Kind 'solution'
            $texts[$id] = Get-DojoHostText -ScriptBlock { Test-Dojo }
        }
    }

    It 'passes every exercise in order' {
        foreach ($id in $ids) {
            $texts[$id] | Should -Match "PASSED\s+$id"
        }
    }

    It 'shows the quiz score' {
        $texts['m01-e08'] | Should -Match '10 of 10 correct = 100 percent, needed 80 percent'
    }

    It 'shows the production note when the module is completed' {
        $texts['m01-e08'] | Should -Match 'Module completed'
        $texts['m01-e08'] | Should -Match 'What goes wrong in production'
        $texts['m01-e07'] | Should -Not -Match 'What goes wrong in production'
    }

    It 'reports that everything is done' {
        $text = Get-DojoHostText -ScriptBlock { Start-Dojo }
        $text | Should -Match 'All available exercises are completed'
    }

    It 'shows a module map with completed exercises' {
        $text = Get-DojoHostText -ScriptBlock { Show-DojoProgress }
        $text | Should -Match '8 of 8'
        ([regex]::Matches($text, '\[x\] m01-e0')).Count | Should -Be 8
    }
}

Describe 'Quiz pass mark' {
    BeforeAll {
        $dojoHome = New-DojoTestHome -Name 'quiz'
        Invoke-DojoPrivate -ScriptBlock {
            $progress = Read-DojoProgress
            foreach ($id in 'm01-e01', 'm01-e02', 'm01-e03', 'm01-e04', 'm01-e05', 'm01-e06', 'm01-e07') {
                (Get-DojoExerciseRecord -Progress $progress -Id $id)['status'] = 'completed'
            }
            $progress['current'] = 'm01-e08'
            Save-DojoProgress -Progress $progress
        }
        $file = Join-Path -Path (Join-Path -Path $dojoHome -ChildPath 'm01') -ChildPath 'm01-e08.ps1'
        $solution = Get-Content -LiteralPath (Join-Path -Path $content -ChildPath 'm01/m01-e08/solution.ps1')
    }

    It 'fails with 70 percent and names the wrong questions without the answers' {
        Copy-DojoAnswer -Id 'm01-e08' -Kind 'wrong'
        $text = Get-DojoHostText -ScriptBlock { Test-Dojo }
        $text | Should -Match 'NOT YET'
        $text | Should -Match '7 of 10 correct = 70 percent'
        $text | Should -Match 'Question 3, Question 4, Question 7'
        $text | Should -Not -Match 'Expected'
    }

    It 'passes with exactly 80 percent' {
        $lines = $solution -replace "^\`$Answer1 = 'c'", "`$Answer1 = 'a'" -replace "^\`$Answer2 = 'a'", "`$Answer2 = 'b'"
        Set-Content -LiteralPath $file -Value $lines
        $text = Get-DojoHostText -ScriptBlock { Test-Dojo }
        $text | Should -Match 'PASSED'
        $text | Should -Match '8 of 10 correct = 80 percent'
    }
}

Describe 'Show-DojoProgress' {
    BeforeAll {
        $dojoHome = New-DojoTestHome -Name 'progress'
        Copy-DojoAnswer -Id 'm01-e01' -Kind 'solution'
        $null = Get-DojoHostText -ScriptBlock { Test-Dojo }
    }

    It 'marks completed, current and locked exercises' {
        $text = Get-DojoHostText -ScriptBlock { Show-DojoProgress }
        $text | Should -Match '\[x\] m01-e01'
        $text | Should -Match '\[>\] m01-e02'
        $text | Should -Match '\[-\] m01-e03'
        $text | Should -Match '1 of 8'
    }

    It 'returns objects with -PassThru' {
        $rows = @(Show-DojoProgress -PassThru)
        $rows.Count | Should -Be 8
        ($rows | Where-Object { $_.Id -eq 'm01-e01' }).State | Should -Be 'completed'
        ($rows | Where-Object { $_.Id -eq 'm01-e02' }).State | Should -Be 'open'
        ($rows | Where-Object { $_.Id -eq 'm01-e08' }).State | Should -Be 'locked'
    }
}

Describe 'Reports' {
    BeforeAll {
        $reportFolder = Join-Path -Path $TestDrive -ChildPath 'teamreports'
        $null = New-Item -Path $reportFolder -ItemType Directory -Force

        $dojoHome = New-DojoTestHome -Name 'report-a'
        Invoke-DojoPrivate -ScriptBlock { $p = Read-DojoProgress; $p['learner'] = 'a.keller'; Save-DojoProgress -Progress $p }
        $null = Get-DojoHostText -ScriptBlock { Test-Dojo; Get-DojoHint }
        Copy-DojoAnswer -Id 'm01-e01' -Kind 'solution'
        $null = Get-DojoHostText -ScriptBlock { Test-Dojo }
        Invoke-DojoPrivate -ScriptBlock { $p = Read-DojoProgress; $p['exercises']['m01-e01']['seconds'] = 600; Save-DojoProgress -Progress $p }
        $reportA = $null
        $reportA = Export-DojoReport -Path $reportFolder 6>$null

        $null = New-DojoTestHome -Name 'report-b'
        Invoke-DojoPrivate -ScriptBlock { $p = Read-DojoProgress; $p['learner'] = 'm.yilmaz'; Save-DojoProgress -Progress $p }
        $null = Get-DojoHostText -ScriptBlock { Export-DojoReport -Path $reportFolder }

        Set-Content -LiteralPath (Join-Path -Path $reportFolder -ChildPath 'notes.json') -Value '{ "kind": "something else" }'
        Set-Content -LiteralPath (Join-Path -Path $reportFolder -ChildPath 'broken.json') -Value '{ not json'
    }

    It 'writes a report with exercises done, attempts, hints and time per module' {
        $reportA | Should -Exist
        $data = Get-Content -LiteralPath $reportA.FullName -Raw -Encoding UTF8 | ConvertFrom-Json
        $data.kind | Should -Be 'PSDojoReport'
        $data.learner | Should -Be 'a.keller'
        $data.totals.completed | Should -Be 1
        $data.totals.attempts | Should -Be 2
        $data.totals.hints | Should -Be 1
        @($data.modules)[0].id | Should -Be 'm01'
        @($data.modules)[0].seconds | Should -Be 600
        @($data.exercises).Count | Should -Be 8
    }

    It 'writes to the learner folder by default' {
        $file = $null
        $file = Export-DojoReport 6>$null
        $file.DirectoryName | Should -Be (Join-Path -Path $env:PSDOJO_HOME -ChildPath 'reports')
    }

    It 'reads a folder of reports into one overview row per learner' {
        $rows = @(Get-DojoTeamReport -Path $reportFolder -WarningAction SilentlyContinue)
        $rows.Count | Should -Be 2
        $first = $rows | Where-Object { $_.Learner -eq 'a.keller' }
        $first.Completed | Should -Be 1
        $first.Total | Should -Be 8
        $first.Percent | Should -Be 13
        $first.Attempts | Should -Be 2
        $first.Hints | Should -Be 1
        $first.Hours | Should -Be 0.2
        ($rows | Where-Object { $_.Learner -eq 'm.yilmaz' }).Completed | Should -Be 0
    }

    It 'renders the overview as one table' {
        $text = Get-DojoTeamReport -Path $reportFolder -WarningAction SilentlyContinue | Out-String -Width 160
        $text | Should -Match 'Learner\s+Done\s+Total\s+Percent\s+Attempts\s+Hints\s+Solutions\s+Hours'
    }

    It 'breaks the numbers down per module with -ByModule' {
        $rows = @(Get-DojoTeamReport -Path $reportFolder -ByModule -WarningAction SilentlyContinue)
        $row = $rows | Where-Object { $_.Learner -eq 'a.keller' -and $_.Module -eq 'm01' }
        $row.Minutes | Should -Be 10
    }

    It 'uses the newest report when a learner has several' {
        $env:PSDOJO_HOME = $dojoHome
        Copy-DojoAnswer -Id 'm01-e02' -Kind 'solution'
        $null = Get-DojoHostText -ScriptBlock { Test-Dojo; Start-Sleep -Milliseconds 1100; Export-DojoReport -Path $reportFolder }
        $rows = @(Get-DojoTeamReport -Path $reportFolder -WarningAction SilentlyContinue)
        $rows.Count | Should -Be 2
        ($rows | Where-Object { $_.Learner -eq 'a.keller' }).Completed | Should -Be 2
    }
}
