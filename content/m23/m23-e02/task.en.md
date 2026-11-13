# Task

A retry counter in a sync script always reports zero retries although the log shows
several. You read the script and predict what each variable holds. Do not run anything.

```powershell
$Retries = 0
$Site = 'Kiel'

function Add-Retry {
    $Retries = $Retries + 1
    $Retries
}

function Add-ScriptRetry {
    $script:Retries = $script:Retries + 1
}

function Get-Greeting {
    "Site $Site"
}

$First = Add-Retry
$Second = Add-Retry
$AfterLocal = $Retries

Add-ScriptRetry
$AfterScript = $Retries

if ($Retries -gt 0) { $Status = 'retried' }
```

1. Store the value of `$Second` in `$Result1`.
2. Store the value of `$AfterLocal` in `$Result2`.
3. Store the value of `$AfterScript` in `$Result3`.
4. Store the output of `Get-Greeting` in `$Result4`.
5. Store the value of `$Status` after the last line in `$Result5`.
