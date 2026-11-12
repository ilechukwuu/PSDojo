function Get-DojoHome {
    [CmdletBinding()]
    param()

    if ($env:PSDOJO_HOME) {
        return $env:PSDOJO_HOME
    }
    return (Join-Path -Path $HOME -ChildPath 'PSDojo')
}

function Get-DojoProgressPath {
    [CmdletBinding()]
    param()

    return (Join-Path -Path (Get-DojoHome) -ChildPath 'progress.json')
}

function Get-DojoLearnerFile {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        $Exercise
    )

    $folder = Join-Path -Path (Get-DojoHome) -ChildPath $Exercise.Module
    return (Join-Path -Path $folder -ChildPath "$($Exercise.Id).ps1")
}

function Write-DojoTextFile {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path,

        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [string]$Text
    )

    $folder = Split-Path -Path $Path -Parent
    if (-not (Test-Path -LiteralPath $folder)) {
        [void](New-Item -Path $folder -ItemType Directory -Force)
    }
    $encoding = New-Object -TypeName System.Text.UTF8Encoding -ArgumentList $false
    [System.IO.File]::WriteAllText($Path, $Text, $encoding)
}

function Get-DojoTimestamp {
    [CmdletBinding()]
    param()

    return [datetime]::UtcNow.ToString('o')
}

function ConvertTo-DojoDate {
    [CmdletBinding()]
    param(
        [Parameter()]
        [AllowNull()]
        $Value
    )

    if ($null -eq $Value -or $Value -eq '') {
        return $null
    }
    if ($Value -is [datetime]) {
        return $Value.ToUniversalTime()
    }
    $styles = [System.Globalization.DateTimeStyles]::RoundtripKind
    $parsed = [datetime]::MinValue
    if ([datetime]::TryParse([string]$Value, [cultureinfo]::InvariantCulture, $styles, [ref]$parsed)) {
        return $parsed.ToUniversalTime()
    }
    return $null
}

function New-DojoProgress {
    [CmdletBinding()]
    param()

    $language = 'en'
    if ([cultureinfo]::CurrentUICulture.TwoLetterISOLanguageName -eq 'de') {
        $language = 'de'
    }
    return @{
        schema    = 1
        learner   = [Environment]::UserName
        language  = $language
        current   = ''
        exercises = @{}
    }
}

function Read-DojoProgress {
    [CmdletBinding()]
    param()

    $path = Get-DojoProgressPath
    $progress = $null
    if (Test-Path -LiteralPath $path) {
        try {
            $progress = Read-DojoJsonFile -Path $path
        }
        catch {
            $backup = "$path.broken"
            Copy-Item -LiteralPath $path -Destination $backup -Force
            Write-Warning -Message (Get-DojoString -Key 'ProgressBroken' -Values $backup)
        }
    }
    if (-not ($progress -is [System.Collections.IDictionary])) {
        $progress = New-DojoProgress
    }
    $defaults = New-DojoProgress
    foreach ($key in $defaults.Keys) {
        if (-not $progress.ContainsKey($key) -or $null -eq $progress[$key]) {
            $progress[$key] = $defaults[$key]
        }
    }
    if (-not ($progress['exercises'] -is [System.Collections.IDictionary])) {
        $progress['exercises'] = @{}
    }
    if ($script:DojoLanguages -notcontains $progress['language']) {
        $progress['language'] = $defaults['language']
    }
    $script:DojoLanguageOverride = $progress['language']
    return $progress
}

function Save-DojoProgress {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.IDictionary]$Progress
    )

    $json = ConvertTo-Json -InputObject $Progress -Depth 10
    Write-DojoTextFile -Path (Get-DojoProgressPath) -Text $json
}

function Get-DojoExerciseRecord {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.IDictionary]$Progress,

        [Parameter(Mandatory = $true)]
        [string]$Id
    )

    $defaults = @{
        status         = 'open'
        attempts       = 0
        hints          = 0
        solutionViewed = $false
        seconds        = 0
        startedAt      = ''
        lastActivity   = ''
        completedAt    = ''
    }
    if (-not ($Progress['exercises'][$Id] -is [System.Collections.IDictionary])) {
        $Progress['exercises'][$Id] = @{}
    }
    $record = $Progress['exercises'][$Id]
    foreach ($key in $defaults.Keys) {
        if (-not $record.ContainsKey($key) -or $null -eq $record[$key]) {
            $record[$key] = $defaults[$key]
        }
    }
    return $record
}

function Update-DojoActivity {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.IDictionary]$Record
    )

    if ($Record['status'] -eq 'completed') {
        return
    }
    $now = [datetime]::UtcNow
    $last = ConvertTo-DojoDate -Value $Record['lastActivity']
    if ($last) {
        $gap = ($now - $last).TotalSeconds
        if ($gap -gt 0 -and $gap -le $script:IdleCapSeconds) {
            $Record['seconds'] = [int]([double]$Record['seconds'] + $gap)
        }
    }
    if (-not $Record['startedAt']) {
        $Record['startedAt'] = $now.ToString('o')
    }
    $Record['lastActivity'] = $now.ToString('o')
}

function Get-DojoExerciseState {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.IDictionary]$Progress,

        [Parameter(Mandatory = $true)]
        [AllowEmptyCollection()]
        [object[]]$Exercises
    )

    $known = @{}
    foreach ($exercise in $Exercises) {
        $known[$exercise.Id] = $true
    }
    $done = @{}
    foreach ($exercise in $Exercises) {
        $record = $Progress['exercises'][$exercise.Id]
        if ($record -is [System.Collections.IDictionary] -and $record['status'] -eq 'completed') {
            $done[$exercise.Id] = $true
        }
    }
    $reasons = @{}
    foreach ($exercise in $Exercises) {
        $reason = Get-DojoUnavailableReason -Exercise $exercise
        if ($reason) {
            $reasons[$exercise.Id] = $reason
        }
    }
    foreach ($exercise in $Exercises) {
        $missing = @($exercise.Prerequisites | Where-Object { $known.ContainsKey($_) -and -not $done.ContainsKey($_) -and -not $reasons.ContainsKey($_) })
        $state = 'open'
        if ($done.ContainsKey($exercise.Id)) {
            $state = 'completed'
        }
        elseif ($reasons.ContainsKey($exercise.Id)) {
            $state = 'unavailable'
        }
        elseif ($missing.Count -gt 0) {
            $state = 'locked'
        }
        [pscustomobject]@{
            Exercise = $exercise
            Id       = $exercise.Id
            State    = $state
            Missing  = $missing
            Reason   = [string]$reasons[$exercise.Id]
        }
    }
}

function Resolve-DojoExercise {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.IDictionary]$Progress,

        [Parameter()]
        [string]$Id
    )

    $exercises = @(Get-DojoExerciseList)
    if ($exercises.Count -eq 0) {
        Write-DojoLine -Text (Get-DojoString -Key 'NoExercises' -Values (Get-DojoContentRoot)) -Color Yellow
        return $null
    }
    $states = @(Get-DojoExerciseState -Progress $Progress -Exercises $exercises)
    $target = $Id
    if (-not $target) {
        $target = $Progress['current']
    }
    if (-not $target) {
        Write-DojoLine -Text (Get-DojoString -Key 'NotStarted') -Color Yellow
        return $null
    }
    $state = $states | Where-Object { $_.Id -eq $target } | Select-Object -First 1
    if (-not $state) {
        Write-DojoLine -Text (Get-DojoString -Key 'UnknownExercise' -Values $target) -Color Yellow
        return $null
    }
    if ($state.State -eq 'locked') {
        Write-DojoLine -Text (Get-DojoString -Key 'Locked' -Values $target, ($state.Missing -join ', ')) -Color Yellow
        return $null
    }
    if ($state.State -eq 'unavailable') {
        Write-DojoLine -Text (Get-DojoString -Key 'Unavailable' -Values $target, $state.Reason) -Color Yellow
        return $null
    }
    return $state
}

function Get-DojoUnavailableReason {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory = $true)]
        $Exercise
    )

    if ($Exercise.MinPowerShell) {
        $minimum = $null
        if ([version]::TryParse([string]$Exercise.MinPowerShell, [ref]$minimum) -and $PSVersionTable.PSVersion -lt $minimum) {
            return (Get-DojoString -Key 'NeedsPowerShell' -Values $Exercise.MinPowerShell)
        }
    }
    $missing = @($Exercise.Requires | Where-Object { -not (Get-Command -Name $_ -ErrorAction SilentlyContinue) })
    if ($missing.Count -gt 0) {
        return (Get-DojoString -Key 'NeedsCommand' -Values ($missing -join ', '))
    }
    return ''
}

function Get-DojoNextOpen {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.IDictionary]$Progress,

        [Parameter(Mandatory = $true)]
        [AllowEmptyCollection()]
        [object[]]$Exercises
    )

    return (Get-DojoExerciseState -Progress $Progress -Exercises $Exercises |
            Where-Object { $_.State -eq 'open' } |
            Select-Object -First 1)
}
