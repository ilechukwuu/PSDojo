BeforeDiscovery {
    . (Join-Path -Path $PSScriptRoot -ChildPath 'TestHelpers.ps1')
    $contentRoot = Join-Path -Path (Get-DojoRepoRoot) -ChildPath 'content'

    $moduleCases = @(
        foreach ($folder in (Get-ChildItem -LiteralPath $contentRoot -Directory | Where-Object { -not $_.Name.StartsWith('_') })) {
            @{ ModuleId = $folder.Name; ModulePath = $folder.FullName }
        }
    )
    $exerciseCases = @(
        foreach ($module in $moduleCases) {
            foreach ($folder in (Get-ChildItem -LiteralPath $module.ModulePath -Directory | Where-Object { -not $_.Name.StartsWith('_') })) {
                @{ Id = $folder.Name; Path = $folder.FullName }
            }
        }
    )
    $scriptCases = @(
        foreach ($file in (Get-ChildItem -LiteralPath $contentRoot -Filter '*.ps1' -Recurse)) {
            @{ Name = $file.FullName.Substring($contentRoot.Length + 1); File = $file.FullName }
        }
    )
}

BeforeAll {
    . (Join-Path -Path $PSScriptRoot -ChildPath 'TestHelpers.ps1')
    Import-DojoModuleForTest
    $savedContent = $env:PSDOJO_CONTENT
    $savedHome = $env:PSDOJO_HOME
    $env:PSDOJO_CONTENT = Join-Path -Path (Get-DojoRepoRoot) -ChildPath 'content'
    $env:PSDOJO_HOME = Join-Path -Path $TestDrive -ChildPath 'home'
    Invoke-DojoPrivate -ScriptBlock { $script:DojoLanguageOverride = 'en' }
    $allExercises = @(Invoke-DojoPrivate -ScriptBlock { Get-DojoExerciseList -IncludeUnapproved })
    $allModules = @(Invoke-DojoPrivate -ScriptBlock { Get-DojoModuleList })

    function Get-LoadedExercise {
        param($Path)
        return ($allExercises | Where-Object { $_.Path -eq $Path } | Select-Object -First 1)
    }

    function Get-WordCount {
        param($File)
        $text = Get-Content -LiteralPath $File -Raw -Encoding UTF8
        $prose = [regex]::Replace($text, '(?s)```.*?```', ' ')
        return ([regex]::Matches($prose, '\S+')).Count
    }

    function Get-CodeBlockCount {
        param($File)
        $text = Get-Content -LiteralPath $File -Raw -Encoding UTF8
        return ([regex]::Matches($text, '(?s)```.*?```')).Count
    }
}

AfterAll {
    $env:PSDOJO_CONTENT = $savedContent
    $env:PSDOJO_HOME = $savedHome
}

Describe 'Content has at least one module' {
    It 'finds modules and exercises' -ForEach @(@{ ModuleCount = $moduleCases.Count; ExerciseCount = $exerciseCases.Count }) {
        $ModuleCount | Should -BeGreaterThan 0
        $ExerciseCount | Should -BeGreaterThan 0
    }
}

Describe 'Module <ModuleId>' -ForEach $moduleCases {
    BeforeAll {
        $module = $allModules | Where-Object { $_.Id -eq $ModuleId } | Select-Object -First 1
        $own = @($allExercises | Where-Object { $_.Module -eq $ModuleId } | Sort-Object -Property Order)
    }

    It 'has a valid module.json' {
        $module | Should -Not -BeNullOrEmpty
        $module.Part | Should -BeIn @(1, 2, 3, 4)
        $module.Order | Should -BeGreaterThan 0
        $module.Title['de'] | Should -Not -BeNullOrEmpty
        $module.Title['en'] | Should -Not -BeNullOrEmpty
    }

    It 'names only existing modules as prerequisites' {
        foreach ($required in $module.Prerequisites) {
            $allModules.Id | Should -Contain $required
        }
    }

    It 'has the production note in <_>' -ForEach @('de', 'en') {
        $file = Join-Path -Path $ModulePath -ChildPath "production.$_.md"
        $file | Should -Exist
        (Get-Item -LiteralPath $file).Length | Should -BeGreaterThan 100
    }

    It 'has at least five exercises' {
        $own.Count | Should -BeGreaterOrEqual 5
    }

    It 'mixes all five exercise types' {
        if ($module.Kind -eq 'capstone') {
            Set-ItResult -Skipped -Because 'capstone modules are exempt'
            return
        }
        ($own.Type | Sort-Object -Unique) -join ', ' | Should -Be 'fix, predict, quiz, refactor, write'
    }

    It 'ends with the quiz' {
        if ($module.Kind -eq 'capstone') {
            Set-ItResult -Skipped -Because 'capstone modules are exempt'
            return
        }
        $own[-1].Type | Should -Be 'quiz'
    }

    It 'numbers its exercises without gaps or duplicates' {
        $own.Order -join ',' | Should -Be ((1..$own.Count) -join ',')
    }
}

Describe 'Exercise <Id>' -ForEach $exerciseCases {
    BeforeAll {
        $exercise = Get-LoadedExercise -Path $Path
        $unavailable = ''
        if ($exercise) {
            $unavailable = Invoke-DojoPrivate -ScriptBlock { param($e) Get-DojoUnavailableReason -Exercise $e } -ArgumentList $exercise
        }
    }

    It 'follows the folder contract and has a valid meta.json' {
        $problems = @(Invoke-DojoPrivate -ScriptBlock { param($p) Test-DojoExerciseFolder -Path $p } -ArgumentList $Path)
        $problems -join '; ' | Should -Be ''
    }

    It 'is loaded by the exercise loader' {
        $exercise | Should -Not -BeNullOrEmpty
    }

    It 'has a non-empty <_>' -ForEach @('lesson.de.md', 'lesson.en.md', 'task.de.md', 'task.en.md') {
        $file = Join-Path -Path $Path -ChildPath $_
        $file | Should -Exist
        (Get-Content -LiteralPath $file -Raw -Encoding UTF8).Trim().Length | Should -BeGreaterThan 40
    }

    It 'keeps <_> within 200 words and gives one worked example' -ForEach @('lesson.de.md', 'lesson.en.md') {
        $file = Join-Path -Path $Path -ChildPath $_
        Get-WordCount -File $file | Should -BeLessOrEqual 200
        Get-CodeBlockCount -File $file | Should -Be 1
    }

    It 'names only earlier, existing exercises as prerequisites' {
        foreach ($required in $exercise.Prerequisites) {
            $other = $allExercises | Where-Object { $_.Id -eq $required } | Select-Object -First 1
            $other | Should -Not -BeNullOrEmpty -Because "prerequisite $required must exist"
            $earlier = ($other.ModuleOrder -lt $exercise.ModuleOrder) -or ($other.ModuleOrder -eq $exercise.ModuleOrder -and $other.Order -lt $exercise.Order)
            $earlier | Should -BeTrue -Because "prerequisite $required must come before $Id"
        }
    }

    It 'has a starter that fails' {
        if ($unavailable) {
            Set-ItResult -Skipped -Because $unavailable
            return
        }
        $result = Invoke-DojoPrivate -ScriptBlock { param($e, $p) Invoke-DojoCheck -Exercise $e -ScriptPath $p } -ArgumentList $exercise, (Join-Path -Path $Path -ChildPath 'starter.ps1')
        $result.Passed | Should -BeFalse
        $allowed = @('TestFailed', 'ScriptError')
        if ($exercise.Type -eq 'fix') {
            $allowed += 'SyntaxError'
        }
        $result.Kind | Should -BeIn $allowed
    }

    It 'has a solution that passes' {
        if ($unavailable) {
            Set-ItResult -Skipped -Because $unavailable
            return
        }
        $result = Invoke-DojoPrivate -ScriptBlock { param($e, $p) Invoke-DojoCheck -Exercise $e -ScriptPath $p } -ArgumentList $exercise, (Join-Path -Path $Path -ChildPath 'solution.ps1')
        $result.Kind | Should -Be 'Passed' -Because "$($result.TestName) $($result.Message)"
        $result.Passed | Should -BeTrue
        $result.PassedCount | Should -Be $result.Total
    }

    It 'has a wrong answer that fails with a helpful message' {
        if ($unavailable) {
            Set-ItResult -Skipped -Because $unavailable
            return
        }
        $result = Invoke-DojoPrivate -ScriptBlock { param($e, $p) Invoke-DojoCheck -Exercise $e -ScriptPath $p } -ArgumentList $exercise, (Join-Path -Path $Path -ChildPath 'wrong.ps1')
        $result.Passed | Should -BeFalse
        $result.Kind | Should -BeIn @('TestFailed', 'ScriptError')

        if ($exercise.Type -eq 'quiz') {
            $result.FailedTests.Count | Should -BeGreaterThan 0
            $result.Expected | Should -Be '' -Because 'a quiz must not reveal the right answer'
        }
        elseif ($result.Kind -eq 'ScriptError') {
            $result.Message | Should -Not -BeNullOrEmpty
            $result.Line | Should -BeGreaterThan 0 -Because 'a script error must point to the line'
        }
        else {
            $result.TestName | Should -Not -BeNullOrEmpty
            "$($result.Expected)$($result.Actual)" | Should -Not -BeNullOrEmpty -Because 'the learner needs expected and actual value'
            $result.Because | Should -Not -BeNullOrEmpty -Because 'the failing test must explain itself with -Because'
        }

        $text = Get-DojoHostText -ScriptBlock { Invoke-DojoPrivate -ScriptBlock { param($e, $r) Write-DojoCheckResult -Exercise $e -Result $r } -ArgumentList $exercise, $result }
        $text | Should -Match ([regex]::Escape($exercise.Concept['en']))
        $text | Should -Not -Match 'at <ScriptBlock>|ScriptStackTrace|Pester\.psm1|\.Tests\.ps1|tests\.ps1'
    }

    It 'never shows the reference solution as its starter' {
        $starter = (Get-Content -LiteralPath (Join-Path -Path $Path -ChildPath 'starter.ps1') -Raw).Trim()
        $solution = (Get-Content -LiteralPath (Join-Path -Path $Path -ChildPath 'solution.ps1') -Raw).Trim()
        $starter | Should -Not -Be $solution
    }
}

Describe 'Script <Name>' -ForEach $scriptCases {
    It 'is plain ASCII so Windows PowerShell 5.1 reads it correctly' {
        $bytes = [System.IO.File]::ReadAllBytes($File)
        @($bytes | Where-Object { $_ -gt 127 }).Count | Should -Be 0
    }
}

Describe 'Ids' {
    It 'are unique across the whole content' {
        $duplicates = @($allExercises | Group-Object -Property Id | Where-Object { $_.Count -gt 1 }).Name -join ', '
        $duplicates | Should -Be ''
    }
}
