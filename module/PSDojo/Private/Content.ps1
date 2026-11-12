<#
PSDojo content contract
=======================

Both front ends (this module and the web app) read only from the content root.
Adding a module or an exercise is done by adding folders. The engine is never changed.

Content root
    $env:PSDOJO_CONTENT if set, else <module>\content, else <repo>\content.

Layout
    content\<moduleId>\module.json
    content\<moduleId>\production.de.md
    content\<moduleId>\production.en.md
    content\<moduleId>\<exerciseId>\...        one folder per exercise
    content\_shared\...                        fixtures and stub functions used by tests.ps1

    Folder names equal the ids. A folder is a module when it holds module.json and an
    exercise when it holds meta.json. Folders starting with an underscore are never
    treated as modules or exercises.

module.json
    id             string   "m01"
    part           int      1 to 4
    order          int      position of the module in the curriculum
    title          object   { "de": "...", "en": "..." }
    prerequisites  array    module ids

production.<lang>.md
    The "what goes wrong in production" note. Shown when the module is completed.

Exercise folder
    meta.json
        id             string   "m01-e01", equals the folder name
        module         string   id of the parent module, equals the parent folder name
        title          object   { "de": "...", "en": "..." }
        type           string   write | fix | predict | refactor | quiz
        order          int      position inside the module
        prerequisites  array    exercise ids that must be completed first
        status         string   draft | reviewed | approved. Only approved reaches a learner.
        concept        object   { "de": "...", "en": "..." } one line shown with a failed check
        passMark       int      optional. Percent of tests that must pass. Default 100, quiz 80.
        placeholder    bool     optional. True for capstones with invented scenarios.
        review         object   optional. Written by the review workflow (reviewer, timestamp, comment).
    lesson.de.md, lesson.en.md
        Concept in at most 200 words plus one worked example in a fenced code block.
    task.de.md, task.en.md
        What the learner has to do.
    starter.ps1
        Copied to the learner folder. Must fail tests.ps1.
    solution.ps1
        Reference solution. Must pass tests.ps1.
    wrong.ps1
        One typical wrong answer. Must fail tests.ps1 with a helpful message.
    hints.json
        { "de": [ "level 1", "level 2", "level 3" ], "en": [ "...", "...", "..." ] }
    tests.ps1
        Pester 5. Starts with param($SolutionPath) and dot sources that file in BeforeAll.
        Graded identically by the local module and the web runner.
    quiz.json
        Only for type quiz.
        { "questions": [ { "id": 1,
                           "text":    { "de": "...", "en": "..." },
                           "options": { "de": [ "...", "..." ], "en": [ "...", "..." ] },
                           "answer":  "b" } ] }
        The learner file assigns $Answer1, $Answer2 ... with the option letter.
        tests.ps1 of a quiz reads quiz.json, one test per question named "Question <id>".
        The web app grades quiz.json directly, so a quiz works without code execution.

File rules
    All .ps1 files are plain ASCII so Windows PowerShell 5.1 reads them correctly.
    All .md and .json files are UTF-8.
    Tests never touch real systems. Admin cmdlets are mocked with fixtures from _shared.
#>

$script:DojoExerciseTypes = @('write', 'fix', 'predict', 'refactor', 'quiz')
$script:DojoStatuses = @('draft', 'reviewed', 'approved')
$script:DojoLanguages = @('de', 'en')
$script:DojoExerciseFiles = @(
    'meta.json'
    'lesson.de.md'
    'lesson.en.md'
    'task.de.md'
    'task.en.md'
    'starter.ps1'
    'solution.ps1'
    'wrong.ps1'
    'hints.json'
    'tests.ps1'
)

function Get-DojoContentRoot {
    [CmdletBinding()]
    param()

    if ($env:PSDOJO_CONTENT) {
        return $env:PSDOJO_CONTENT
    }
    $bundled = Join-Path -Path $script:ModuleRoot -ChildPath 'content'
    if (Test-Path -LiteralPath $bundled) {
        return $bundled
    }
    $repo = Split-Path -Path (Split-Path -Path $script:ModuleRoot -Parent) -Parent
    return (Join-Path -Path $repo -ChildPath 'content')
}

function Read-DojoJsonFile {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    $text = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
    $object = ConvertFrom-Json -InputObject $text
    return (ConvertTo-DojoHashtable -InputObject $object)
}

function ConvertTo-DojoHashtable {
    [CmdletBinding()]
    param(
        [Parameter()]
        [AllowNull()]
        $InputObject
    )

    if ($null -eq $InputObject) {
        return $null
    }
    if ($InputObject -is [datetime]) {
        return $InputObject.ToUniversalTime().ToString('o')
    }
    if ($InputObject -is [string] -or $InputObject -is [System.ValueType]) {
        return $InputObject
    }
    if ($InputObject -is [System.Collections.IDictionary]) {
        $table = @{}
        foreach ($key in @($InputObject.Keys)) {
            $table[[string]$key] = ConvertTo-DojoHashtable -InputObject $InputObject[$key]
        }
        return $table
    }
    if ($InputObject -is [System.Collections.IEnumerable]) {
        $list = New-Object -TypeName System.Collections.ArrayList
        foreach ($item in $InputObject) {
            [void]$list.Add((ConvertTo-DojoHashtable -InputObject $item))
        }
        return , $list.ToArray()
    }
    if ($InputObject -is [System.Management.Automation.PSCustomObject]) {
        $table = @{}
        foreach ($property in $InputObject.PSObject.Properties) {
            $table[$property.Name] = ConvertTo-DojoHashtable -InputObject $property.Value
        }
        return $table
    }
    return $InputObject
}

function Get-DojoModuleList {
    [CmdletBinding()]
    param()

    $root = Get-DojoContentRoot
    if (-not (Test-Path -LiteralPath $root)) {
        return @()
    }
    $modules = New-Object -TypeName System.Collections.ArrayList
    foreach ($folder in (Get-ChildItem -LiteralPath $root -Directory)) {
        if ($folder.Name.StartsWith('_')) {
            continue
        }
        $file = Join-Path -Path $folder.FullName -ChildPath 'module.json'
        if (-not (Test-Path -LiteralPath $file)) {
            continue
        }
        try {
            $data = Read-DojoJsonFile -Path $file
        }
        catch {
            continue
        }
        if ($data['id'] -ne $folder.Name) {
            continue
        }
        [void]$modules.Add([pscustomobject]@{
                Id            = [string]$data['id']
                Part          = [int]$data['part']
                Order         = [int]$data['order']
                Title         = $data['title']
                Prerequisites = @($data['prerequisites'] | Where-Object { $_ })
                Path          = $folder.FullName
            })
    }
    return @($modules | Sort-Object -Property Order, Id)
}

function Test-DojoExerciseFolder {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    $problems = New-Object -TypeName System.Collections.ArrayList
    $folderName = Split-Path -Path $Path -Leaf
    $moduleName = Split-Path -Path (Split-Path -Path $Path -Parent) -Leaf

    foreach ($name in $script:DojoExerciseFiles) {
        $file = Join-Path -Path $Path -ChildPath $name
        if (-not (Test-Path -LiteralPath $file)) {
            [void]$problems.Add("missing file $name")
        }
        elseif ((Get-Item -LiteralPath $file).Length -eq 0) {
            [void]$problems.Add("empty file $name")
        }
    }

    $metaFile = Join-Path -Path $Path -ChildPath 'meta.json'
    if (-not (Test-Path -LiteralPath $metaFile)) {
        return $problems.ToArray()
    }
    try {
        $meta = Read-DojoJsonFile -Path $metaFile
    }
    catch {
        [void]$problems.Add('meta.json is not valid JSON')
        return $problems.ToArray()
    }

    foreach ($key in 'id', 'module', 'title', 'type', 'order', 'prerequisites', 'status', 'concept') {
        if (-not $meta.ContainsKey($key)) {
            [void]$problems.Add("meta.json has no field $key")
        }
    }
    if ($meta['id'] -ne $folderName) {
        [void]$problems.Add('meta.json id does not equal the folder name')
    }
    if ($meta['module'] -ne $moduleName) {
        [void]$problems.Add('meta.json module does not equal the parent folder name')
    }
    if ($script:DojoExerciseTypes -notcontains $meta['type']) {
        [void]$problems.Add("meta.json type '$($meta['type'])' is not one of $($script:DojoExerciseTypes -join ', ')")
    }
    if ($script:DojoStatuses -notcontains $meta['status']) {
        [void]$problems.Add("meta.json status '$($meta['status'])' is not one of $($script:DojoStatuses -join ', ')")
    }
    if (-not ($meta['order'] -is [int] -or $meta['order'] -is [long]) -or $meta['order'] -lt 1) {
        [void]$problems.Add('meta.json order is not a positive whole number')
    }
    foreach ($key in 'title', 'concept') {
        foreach ($language in $script:DojoLanguages) {
            $value = $null
            if ($meta[$key] -is [System.Collections.IDictionary]) {
                $value = $meta[$key][$language]
            }
            if ([string]::IsNullOrWhiteSpace([string]$value)) {
                [void]$problems.Add("meta.json $key has no text for $language")
            }
        }
    }

    $hintFile = Join-Path -Path $Path -ChildPath 'hints.json'
    if (Test-Path -LiteralPath $hintFile) {
        try {
            $hints = Read-DojoJsonFile -Path $hintFile
            foreach ($language in $script:DojoLanguages) {
                $levels = @($hints[$language] | Where-Object { -not [string]::IsNullOrWhiteSpace([string]$_) })
                if ($levels.Count -ne 3) {
                    [void]$problems.Add("hints.json needs exactly three hints for $language")
                }
            }
        }
        catch {
            [void]$problems.Add('hints.json is not valid JSON')
        }
    }

    if ($meta['type'] -eq 'quiz') {
        $quizFile = Join-Path -Path $Path -ChildPath 'quiz.json'
        if (-not (Test-Path -LiteralPath $quizFile)) {
            [void]$problems.Add('missing file quiz.json')
        }
        else {
            try {
                $quiz = Read-DojoJsonFile -Path $quizFile
                $questions = @($quiz['questions'])
                if ($questions.Count -lt 5) {
                    [void]$problems.Add('quiz.json needs at least five questions')
                }
                $expectedId = 1
                foreach ($question in $questions) {
                    if ($question['id'] -ne $expectedId) {
                        [void]$problems.Add("quiz.json question ids must count up from 1, found $($question['id'])")
                    }
                    $expectedId++
                    $count = 0
                    foreach ($language in $script:DojoLanguages) {
                        if ([string]::IsNullOrWhiteSpace([string]$question['text'][$language])) {
                            [void]$problems.Add("quiz.json question $($question['id']) has no text for $language")
                        }
                        $options = @($question['options'][$language])
                        if ($options.Count -lt 2) {
                            [void]$problems.Add("quiz.json question $($question['id']) needs options for $language")
                        }
                        if ($count -ne 0 -and $options.Count -ne $count) {
                            [void]$problems.Add("quiz.json question $($question['id']) has a different number of options per language")
                        }
                        $count = $options.Count
                    }
                    $letters = 'abcdefgh'.Substring(0, [Math]::Min($count, 8)).ToCharArray() | ForEach-Object { [string]$_ }
                    if ($letters -notcontains $question['answer']) {
                        [void]$problems.Add("quiz.json question $($question['id']) has no valid answer letter")
                    }
                }
            }
            catch {
                [void]$problems.Add('quiz.json is not valid JSON')
            }
        }
    }

    return $problems.ToArray()
}

function Get-DojoExerciseList {
    [CmdletBinding()]
    param(
        [Parameter()]
        [switch]$IncludeUnapproved
    )

    $exercises = New-Object -TypeName System.Collections.ArrayList
    foreach ($module in (Get-DojoModuleList)) {
        foreach ($folder in (Get-ChildItem -LiteralPath $module.Path -Directory)) {
            if ($folder.Name.StartsWith('_')) {
                continue
            }
            $metaFile = Join-Path -Path $folder.FullName -ChildPath 'meta.json'
            if (-not (Test-Path -LiteralPath $metaFile)) {
                continue
            }
            if (@(Test-DojoExerciseFolder -Path $folder.FullName).Count -gt 0) {
                continue
            }
            $meta = Read-DojoJsonFile -Path $metaFile
            if (-not $IncludeUnapproved -and $meta['status'] -ne 'approved') {
                continue
            }
            $passMark = 100
            if ($meta['type'] -eq 'quiz') {
                $passMark = 80
            }
            if ($meta.ContainsKey('passMark') -and $meta['passMark']) {
                $passMark = [int]$meta['passMark']
            }
            [void]$exercises.Add([pscustomobject]@{
                    Id            = [string]$meta['id']
                    Module        = [string]$meta['module']
                    ModuleOrder   = $module.Order
                    Title         = $meta['title']
                    Type          = [string]$meta['type']
                    Order         = [int]$meta['order']
                    Prerequisites = @($meta['prerequisites'] | Where-Object { $_ })
                    Status        = [string]$meta['status']
                    Concept       = $meta['concept']
                    PassMark      = $passMark
                    Placeholder   = [bool]$meta['placeholder']
                    Path          = $folder.FullName
                })
        }
    }
    return @($exercises | Sort-Object -Property ModuleOrder, Order, Id)
}

function Get-DojoExerciseText {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        $Exercise,

        [Parameter(Mandatory = $true)]
        [ValidateSet('lesson', 'task')]
        [string]$Kind,

        [Parameter(Mandatory = $true)]
        [string]$Language
    )

    $file = Join-Path -Path $Exercise.Path -ChildPath "$Kind.$Language.md"
    return (Get-Content -LiteralPath $file -Raw -Encoding UTF8)
}

function Get-DojoQuiz {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        $Exercise
    )

    $file = Join-Path -Path $Exercise.Path -ChildPath 'quiz.json'
    $quiz = Read-DojoJsonFile -Path $file
    return @($quiz['questions'])
}
