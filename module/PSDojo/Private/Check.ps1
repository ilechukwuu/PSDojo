$script:DojoCheckScript = @'
param($TestsPath, $ScriptPath, $StopOnFailure, $MinPester)

Import-Module -Name Pester -MinimumVersion $MinPester -ErrorAction Stop

$container = New-PesterContainer -Path $TestsPath -Data @{ SolutionPath = $ScriptPath }
$configuration = New-PesterConfiguration
$configuration.Run.Container = $container
$configuration.Run.PassThru = $true
$configuration.Output.Verbosity = 'None'
if ($StopOnFailure) {
    try {
        $configuration.Run.SkipRemainingOnFailure = 'Run'
    }
    catch {
        $null = $_
    }
}
$run = Invoke-Pester -Configuration $configuration

$tests = New-Object -TypeName System.Collections.ArrayList
foreach ($test in $run.Tests) {
    $item = @{
        Name      = [string]$test.ExpandedName
        Result    = [string]$test.Result
        Assertion = $false
        Message   = ''
        Expected  = ''
        Actual    = ''
        Because   = ''
        Line      = 0
    }
    if ($test.Result -eq 'Failed') {
        $record = $null
        if ($test.ErrorRecord -and $test.ErrorRecord.Count -gt 0) {
            $record = $test.ErrorRecord[0]
        }
        $block = $test.Block
        while (-not $record -and $block) {
            if ($block.ErrorRecord -and $block.ErrorRecord.Count -gt 0) {
                $record = $block.ErrorRecord[0]
            }
            $block = $block.Parent
        }
        if ($record) {
            $item.Message = [string]$record.Exception.Message
            if ($record.FullyQualifiedErrorId -eq 'PesterAssertionFailed') {
                $item.Assertion = $true
                $target = $record.TargetObject
                if ($target -is [System.Collections.IDictionary] -and $target['ShouldResult']) {
                    $expect = $target['ShouldResult'].ExpectResult
                    if ($expect) {
                        $item.Expected = [string]$expect.Expected
                        $item.Actual = [string]$expect.Actual
                        $item.Because = [string]$expect.Because
                    }
                }
            }
            else {
                if ($record.InvocationInfo -and $record.InvocationInfo.ScriptName -eq $ScriptPath) {
                    $item.Line = [int]$record.InvocationInfo.ScriptLineNumber
                }
                elseif ($record.ScriptStackTrace) {
                    foreach ($frame in ($record.ScriptStackTrace -split "`r?`n")) {
                        if ($frame.Contains($ScriptPath) -and $frame -match '(\d+)\s*$') {
                            $item.Line = [int]$Matches[1]
                            break
                        }
                    }
                }
            }
        }
    }
    [void]$tests.Add($item)
}

$containerError = ''
foreach ($failed in ($run.Containers | Where-Object { $_.Result -eq 'Failed' -and $_.ErrorRecord })) {
    if ($failed.ErrorRecord.Count -gt 0) {
        $containerError = [string]$failed.ErrorRecord[0].Exception.Message
    }
}

@{
    Tests          = $tests.ToArray()
    ContainerError = $containerError
}
'@

function New-DojoCheckResult {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        $Exercise,

        [Parameter(Mandatory = $true)]
        [string]$Kind
    )

    return [pscustomobject]@{
        PSTypeName  = 'PSDojo.CheckResult'
        Id          = $Exercise.Id
        Passed      = $false
        Kind        = $Kind
        Total       = 0
        PassedCount = 0
        Score       = 0
        PassMark    = $Exercise.PassMark
        TestName    = ''
        Expected    = ''
        Actual      = ''
        Because     = ''
        Message     = ''
        Line        = 0
        FailedTests = @()
    }
}

function Invoke-DojoCheck {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        $Exercise,

        [Parameter(Mandatory = $true)]
        [string]$ScriptPath,

        [Parameter()]
        [int]$TimeoutSeconds = $script:CheckTimeoutSeconds
    )

    if (-not (Test-Path -LiteralPath $ScriptPath)) {
        $result = New-DojoCheckResult -Exercise $Exercise -Kind 'Missing'
        $result.Message = $ScriptPath
        return $result
    }
    $ScriptPath = (Resolve-Path -LiteralPath $ScriptPath).ProviderPath

    $tokens = $null
    $parseErrors = $null
    [void][System.Management.Automation.Language.Parser]::ParseFile($ScriptPath, [ref]$tokens, [ref]$parseErrors)
    if ($parseErrors -and $parseErrors.Count -gt 0) {
        $result = New-DojoCheckResult -Exercise $Exercise -Kind 'SyntaxError'
        $result.Message = [string]$parseErrors[0].Message
        $result.Line = [int]$parseErrors[0].Extent.StartLineNumber
        return $result
    }

    $testsPath = Join-Path -Path $Exercise.Path -ChildPath 'tests.ps1'
    $stopOnFailure = ($Exercise.PassMark -ge 100)
    $output = $null
    $failure = ''
    $timedOut = $false

    $runspace = [runspacefactory]::CreateRunspace([initialsessionstate]::CreateDefault())
    $runspace.Open()
    $shell = [powershell]::Create()
    $shell.Runspace = $runspace
    try {
        [void]$shell.AddScript($script:DojoCheckScript)
        [void]$shell.AddParameters(@{
                TestsPath     = $testsPath
                ScriptPath    = $ScriptPath
                StopOnFailure = $stopOnFailure
                MinPester     = $script:MinPester.ToString()
            })
        $handle = $shell.BeginInvoke()
        if ($handle.AsyncWaitHandle.WaitOne($TimeoutSeconds * 1000)) {
            try {
                $output = @($shell.EndInvoke($handle))
            }
            catch {
                $failure = [string]$_.Exception.Message
                if ($_.Exception.InnerException) {
                    $failure = [string]$_.Exception.InnerException.Message
                }
            }
        }
        else {
            $timedOut = $true
            [void]$shell.BeginStop($null, $null)
        }
    }
    finally {
        if (-not $timedOut) {
            $shell.Dispose()
            $runspace.Dispose()
        }
    }

    if ($timedOut) {
        $result = New-DojoCheckResult -Exercise $Exercise -Kind 'Timeout'
        $result.Message = [string]$TimeoutSeconds
        return $result
    }

    $data = $null
    if ($output) {
        $data = $output | Where-Object { $_ -is [System.Collections.IDictionary] -and $_.ContainsKey('Tests') } | Select-Object -Last 1
    }
    if (-not $data) {
        $result = New-DojoCheckResult -Exercise $Exercise -Kind 'EngineError'
        $result.Message = $failure
        return $result
    }
    $tests = @($data['Tests'])
    if ($tests.Count -eq 0) {
        $result = New-DojoCheckResult -Exercise $Exercise -Kind 'EngineError'
        $result.Message = [string]$data['ContainerError']
        return $result
    }

    $passed = @($tests | Where-Object { $_['Result'] -eq 'Passed' })
    $failed = @($tests | Where-Object { $_['Result'] -eq 'Failed' })
    $result = New-DojoCheckResult -Exercise $Exercise -Kind 'Passed'
    $result.Total = $tests.Count
    $result.PassedCount = $passed.Count
    $result.Score = [int][Math]::Floor(100 * $passed.Count / $tests.Count)
    $result.FailedTests = @($tests | Where-Object { $_['Result'] -ne 'Passed' } | ForEach-Object { $_['Name'] })
    $result.Passed = ($result.Score -ge $Exercise.PassMark)
    if ($result.Passed) {
        return $result
    }

    $result.Kind = 'TestFailed'
    if ($Exercise.Type -eq 'quiz') {
        return $result
    }
    if ($failed.Count -gt 0) {
        $first = $failed[0]
        $result.TestName = $first['Name']
        $result.Expected = $first['Expected']
        $result.Actual = $first['Actual']
        $result.Because = $first['Because']
        $result.Message = $first['Message']
        $result.Line = $first['Line']
        if (-not $first['Assertion']) {
            $result.Kind = 'ScriptError'
        }
    }
    return $result
}

function Write-DojoCheckResult {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        $Exercise,

        [Parameter(Mandatory = $true)]
        $Result
    )

    $title = Get-DojoLocalText -Table $Exercise.Title
    $concept = Get-DojoLocalText -Table $Exercise.Concept
    Write-DojoLine
    if ($Result.Passed) {
        Write-DojoLine -Text ('  ' + (Get-DojoString -Key 'Passed' -Values $Exercise.Id, $title)) -Color Green
        if ($Exercise.Type -eq 'quiz') {
            Write-DojoField -Label (Get-DojoString -Key 'LabelScore') -Value (Get-DojoString -Key 'ScoreLine' -Values $Result.PassedCount, $Result.Total, $Result.Score, $Result.PassMark)
        }
        return
    }

    Write-DojoLine -Text ('  ' + (Get-DojoString -Key 'Failed' -Values $Exercise.Id, $title)) -Color Red
    switch ($Result.Kind) {
        'Missing' {
            Write-DojoField -Label (Get-DojoString -Key 'LabelProblem') -Value (Get-DojoString -Key 'FileMissing' -Values $Result.Message)
        }
        'SyntaxError' {
            Write-DojoField -Label (Get-DojoString -Key 'LabelProblem') -Value (Get-DojoString -Key 'SyntaxError')
            Write-DojoField -Label (Get-DojoString -Key 'LabelLine') -Value ([string]$Result.Line)
            Write-DojoField -Label (Get-DojoString -Key 'LabelError') -Value $Result.Message
        }
        'Timeout' {
            Write-DojoField -Label (Get-DojoString -Key 'LabelProblem') -Value (Get-DojoString -Key 'Timeout' -Values $Result.Message)
        }
        'EngineError' {
            Write-DojoField -Label (Get-DojoString -Key 'LabelProblem') -Value (Get-DojoString -Key 'EngineError')
            if ($Result.Message) {
                Write-DojoField -Label (Get-DojoString -Key 'LabelError') -Value $Result.Message
            }
        }
        'ScriptError' {
            Write-DojoField -Label (Get-DojoString -Key 'LabelProblem') -Value (Get-DojoString -Key 'ScriptError')
            if ($Result.Line -gt 0) {
                Write-DojoField -Label (Get-DojoString -Key 'LabelLine') -Value ([string]$Result.Line)
            }
            Write-DojoField -Label (Get-DojoString -Key 'LabelError') -Value $Result.Message
        }
        default {
            if ($Exercise.Type -eq 'quiz') {
                Write-DojoField -Label (Get-DojoString -Key 'LabelScore') -Value (Get-DojoString -Key 'ScoreLine' -Values $Result.PassedCount, $Result.Total, $Result.Score, $Result.PassMark)
                Write-DojoField -Label (Get-DojoString -Key 'LabelWrong') -Value ($Result.FailedTests -join ', ')
            }
            else {
                Write-DojoField -Label (Get-DojoString -Key 'LabelTest') -Value $Result.TestName
                if ($Result.Expected -or $Result.Actual) {
                    Write-DojoField -Label (Get-DojoString -Key 'LabelExpected') -Value $Result.Expected
                    Write-DojoField -Label (Get-DojoString -Key 'LabelActual') -Value $Result.Actual
                    if ($Result.Because) {
                        Write-DojoField -Label (Get-DojoString -Key 'LabelWhy') -Value $Result.Because
                    }
                }
                else {
                    Write-DojoField -Label (Get-DojoString -Key 'LabelMessage') -Value $Result.Message
                }
            }
        }
    }
    if ($Result.Kind -ne 'EngineError') {
        Write-DojoField -Label (Get-DojoString -Key 'LabelConcept') -Value $concept
        Write-DojoField -Label (Get-DojoString -Key 'LabelNext') -Value (Get-DojoString -Key 'NextAfterFail')
    }
}
