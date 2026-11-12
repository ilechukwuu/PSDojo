function Get-DojoLanguage {
    [CmdletBinding()]
    param()

    if ($script:DojoLanguageOverride) {
        return $script:DojoLanguageOverride
    }
    $path = Get-DojoProgressPath
    if (Test-Path -LiteralPath $path) {
        try {
            $progress = Read-DojoJsonFile -Path $path
            if ($script:DojoLanguages -contains $progress['language']) {
                return $progress['language']
            }
        }
        catch {
            Write-Verbose -Message 'progress.json could not be read, falling back to the UI culture.'
        }
    }
    if ([cultureinfo]::CurrentUICulture.TwoLetterISOLanguageName -eq 'de') {
        return 'de'
    }
    return 'en'
}

function Get-DojoString {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Key,

        [Parameter()]
        [object[]]$Values = @()
    )

    $language = Get-DojoLanguage
    if (-not $script:StringCache.ContainsKey($language)) {
        $folder = Join-Path -Path $script:ModuleRoot -ChildPath 'Strings'
        $file = Join-Path -Path $folder -ChildPath "$language.json"
        $script:StringCache[$language] = Read-DojoJsonFile -Path $file
    }
    $text = $script:StringCache[$language][$Key]
    if ($null -eq $text) {
        return $Key
    }
    if ($Values.Count -gt 0) {
        return ($text -f $Values)
    }
    return $text
}

function Write-DojoLine {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [AllowEmptyString()]
        [AllowNull()]
        [string]$Text = '',

        [Parameter()]
        [string]$Color
    )

    if ($Color) {
        Write-Host -Object $Text -ForegroundColor $Color
    }
    else {
        Write-Host -Object $Text
    }
}

function Write-DojoField {
    [CmdletBinding()]
    param(
        [Parameter()]
        [AllowEmptyString()]
        [string]$Label = '',

        [Parameter()]
        [AllowNull()]
        [AllowEmptyString()]
        [string]$Value,

        [Parameter()]
        [string]$Color
    )

    $lines = @(([string]$Value) -split "`r?`n")
    $first = $true
    foreach ($line in $lines) {
        if ($first -and $Label) {
            Write-DojoLine -Text ('  {0,-10}: {1}' -f $Label, $line) -Color $Color
            $first = $false
        }
        else {
            Write-DojoLine -Text ('  {0,-10}  {1}' -f '', $line) -Color $Color
        }
    }
}

function ConvertTo-DojoPlainText {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [string]$Markdown
    )

    $output = New-Object -TypeName System.Collections.ArrayList
    $inCode = $false
    foreach ($line in ($Markdown -split "`r?`n")) {
        if ($line -match '^\s*```') {
            $inCode = -not $inCode
            continue
        }
        if ($inCode) {
            [void]$output.Add('    ' + $line)
            continue
        }
        if ($line -match '^(#+)\s+(.*)$') {
            $title = $Matches[2].Trim()
            $rule = '-'
            if ($Matches[1].Length -eq 1) {
                $rule = '='
            }
            [void]$output.Add($title)
            [void]$output.Add($rule * $title.Length)
            continue
        }
        $plain = $line -replace '\*\*([^*]+)\*\*', '$1'
        $plain = $plain -replace '`([^`]+)`', '$1'
        [void]$output.Add($plain)
    }
    while ($output.Count -gt 0 -and [string]::IsNullOrWhiteSpace($output[$output.Count - 1])) {
        $output.RemoveAt($output.Count - 1)
    }
    return $output.ToArray()
}

function Write-DojoMarkdown {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [string]$Markdown
    )

    foreach ($line in (ConvertTo-DojoPlainText -Markdown $Markdown)) {
        Write-DojoLine -Text $line
    }
}

function Write-DojoRule {
    [CmdletBinding()]
    param()

    Write-DojoLine -Text ('-' * 72)
}

function Get-DojoLocalText {
    [CmdletBinding()]
    param(
        [Parameter()]
        $Table
    )

    if (-not ($Table -is [System.Collections.IDictionary])) {
        return [string]$Table
    }
    $language = Get-DojoLanguage
    if ($Table[$language]) {
        return [string]$Table[$language]
    }
    return [string]$Table['en']
}
