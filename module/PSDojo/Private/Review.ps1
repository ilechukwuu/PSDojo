$script:DojoMetaKeyOrder = @(
    'id'
    'module'
    'title'
    'type'
    'order'
    'prerequisites'
    'status'
    'concept'
    'passMark'
    'minPowerShell'
    'requires'
    'placeholder'
    'review'
    'reviewHistory'
    'de'
    'en'
    'action'
    'from'
    'to'
    'reviewer'
    'timestamp'
    'comment'
)

function Get-DojoReviewExercise {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Id
    )

    $exercise = Get-DojoExerciseList -IncludeUnapproved | Where-Object { $_.Id -eq $Id } | Select-Object -First 1
    if (-not $exercise) {
        Write-Error -Message (Get-DojoString -Key 'ReviewUnknown' -Values $Id) -Category ObjectNotFound
        return $null
    }
    return $exercise
}

function Test-DojoExerciseQuality {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        $Exercise
    )

    $checks = New-Object -TypeName System.Collections.ArrayList
    $problems = @(Test-DojoExerciseFolder -Path $Exercise.Path)
    [void]$checks.Add([pscustomobject]@{ Check = 'contract'; Ok = ($problems.Count -eq 0); Detail = ($problems -join '; ') })

    $reason = Get-DojoUnavailableReason -Exercise $Exercise
    if ($reason) {
        [void]$checks.Add([pscustomobject]@{ Check = 'host'; Ok = $false; Detail = $reason })
        return $checks.ToArray()
    }

    $expectations = @(
        @{ File = 'starter.ps1'; MustPass = $false }
        @{ File = 'solution.ps1'; MustPass = $true }
        @{ File = 'wrong.ps1'; MustPass = $false }
    )
    foreach ($expectation in $expectations) {
        $result = Invoke-DojoCheck -Exercise $Exercise -ScriptPath (Join-Path -Path $Exercise.Path -ChildPath $expectation.File)
        $ok = ($result.Passed -eq $expectation.MustPass) -and $result.Kind -ne 'EngineError' -and $result.Kind -ne 'Timeout'
        $detail = '{0}, {1} of {2} tests passed' -f $result.Kind, $result.PassedCount, $result.Total
        if (-not $result.Passed -and $result.TestName) {
            $detail = $detail + ', first failure: ' + $result.TestName
        }
        [void]$checks.Add([pscustomobject]@{ Check = $expectation.File; Ok = $ok; Detail = $detail })
    }
    return $checks.ToArray()
}

function Set-DojoReviewState {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        $Exercise,

        [Parameter(Mandatory = $true)]
        [ValidateSet('approve', 'reject')]
        [string]$Action,

        [Parameter(Mandatory = $true)]
        [string]$NewStatus,

        [Parameter(Mandatory = $true)]
        [string]$Reviewer,

        [Parameter()]
        [AllowEmptyString()]
        [string]$Comment = ''
    )

    $file = Join-Path -Path $Exercise.Path -ChildPath 'meta.json'
    $meta = Read-DojoJsonFile -Path $file
    $entry = @{
        action    = $Action
        from      = [string]$meta['status']
        to        = $NewStatus
        reviewer  = $Reviewer
        timestamp = Get-DojoTimestamp
        comment   = $Comment
    }
    $history = New-Object -TypeName System.Collections.ArrayList
    foreach ($item in @($meta['reviewHistory'] | Where-Object { $_ })) {
        [void]$history.Add($item)
    }
    [void]$history.Add($entry)
    $meta['status'] = $NewStatus
    $meta['review'] = $entry
    $meta['reviewHistory'] = $history.ToArray()

    if ($PSCmdlet.ShouldProcess($file, "$Action, status $($entry['from']) -> $NewStatus")) {
        $json = ConvertTo-DojoJson -Value $meta -KeyOrder $script:DojoMetaKeyOrder
        Write-DojoTextFile -Path $file -Text ($json + "`n")
        return $entry
    }
    return $null
}

function Write-DojoSection {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Title
    )

    Write-DojoLine
    Write-DojoLine -Text ('=== ' + $Title + ' ' + ('=' * [Math]::Max(3, 66 - $Title.Length))) -Color Cyan
}

function Write-DojoCodeFile {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    $number = 1
    foreach ($line in (Get-Content -LiteralPath $Path -Encoding UTF8)) {
        Write-DojoLine -Text ('{0,4}  {1}' -f $number, $line)
        $number++
    }
}
