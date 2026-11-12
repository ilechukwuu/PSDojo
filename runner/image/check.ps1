$nonce = [Console]::In.ReadLine()

Import-Module -Name PSDojo -ErrorAction Stop

$exerciseFolder = Get-ChildItem -LiteralPath '/job/content' -Directory |
    Where-Object { -not $_.Name.StartsWith('_') } |
    ForEach-Object { Get-ChildItem -LiteralPath $_.FullName -Directory } |
    Select-Object -First 1

$meta = Get-Content -LiteralPath (Join-Path -Path $exerciseFolder.FullName -ChildPath 'meta.json') -Raw -Encoding UTF8 | ConvertFrom-Json
$passMark = 100
if ($meta.type -eq 'quiz') {
    $passMark = 80
}
if ($meta.PSObject.Properties.Name -contains 'passMark' -and $meta.passMark) {
    $passMark = [int]$meta.passMark
}
$exercise = [pscustomobject]@{
    Id       = [string]$meta.id
    Type     = [string]$meta.type
    PassMark = $passMark
    Path     = $exerciseFolder.FullName
}

$module = Get-Module -Name PSDojo
$result = & $module { param($e, $p) Invoke-DojoCheck -Exercise $e -ScriptPath $p -TimeoutSeconds 60 } $exercise '/job/learner.ps1'

$payload = [ordered]@{
    passed      = [bool]$result.Passed
    kind        = [string]$result.Kind
    total       = [int]$result.Total
    passedCount = [int]$result.PassedCount
    testName    = [string]$result.TestName
    expected    = [string]$result.Expected
    actual      = [string]$result.Actual
    because     = [string]$result.Because
    message     = [string]$result.Message
    line        = [int]$result.Line
    failedTests = @($result.FailedTests)
}
[Console]::Out.WriteLine('PSDOJO-RESULT-' + $nonce + ' ' + (ConvertTo-Json -InputObject $payload -Compress -Depth 4))
