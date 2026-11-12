function Get-DojoRepoRoot {
    return (Split-Path -Path $PSScriptRoot -Parent)
}

function Import-DojoModuleForTest {
    $manifest = Join-Path -Path (Get-DojoRepoRoot) -ChildPath 'module/PSDojo/PSDojo.psd1'
    Import-Module -Name $manifest -Force
}

function New-DojoTestContent {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Destination,

        [string[]]$Approved = @(),

        [string[]]$Reviewed = @(),

        [switch]$ApproveAll,

        [string[]]$Module = @('m01')
    )

    $source = Join-Path -Path (Get-DojoRepoRoot) -ChildPath 'content'
    if (Test-Path -LiteralPath $Destination) {
        Remove-Item -LiteralPath $Destination -Recurse -Force
    }
    $null = New-Item -Path $Destination -ItemType Directory -Force
    foreach ($folder in (Get-ChildItem -LiteralPath $source -Directory)) {
        if ($folder.Name.StartsWith('_') -or $Module -contains $folder.Name) {
            Copy-Item -LiteralPath $folder.FullName -Destination (Join-Path -Path $Destination -ChildPath $folder.Name) -Recurse
        }
    }
    $encoding = New-Object -TypeName System.Text.UTF8Encoding -ArgumentList $false
    foreach ($file in (Get-ChildItem -LiteralPath $Destination -Filter 'meta.json' -Recurse)) {
        $id = Split-Path -Path $file.DirectoryName -Leaf
        $status = 'draft'
        if ($ApproveAll -or $Approved -contains $id) {
            $status = 'approved'
        }
        elseif ($Reviewed -contains $id) {
            $status = 'reviewed'
        }
        $text = [System.IO.File]::ReadAllText($file.FullName, $encoding)
        $text = $text -replace '"status"\s*:\s*"[a-z]+"', ('"status": "{0}"' -f $status)
        [System.IO.File]::WriteAllText($file.FullName, $text, $encoding)
    }
    return $Destination
}

function Set-DojoTestMeta {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ContentRoot,

        [Parameter(Mandatory = $true)]
        [string]$Id,

        [Parameter(Mandatory = $true)]
        [hashtable]$Values
    )

    $file = Join-Path -Path (Join-Path -Path (Join-Path -Path $ContentRoot -ChildPath $Id.Substring(0, 3)) -ChildPath $Id) -ChildPath 'meta.json'
    Invoke-DojoPrivate -ScriptBlock {
        param($path, $values)
        $meta = Read-DojoJsonFile -Path $path
        foreach ($key in $values.Keys) {
            $meta[$key] = $values[$key]
        }
        Write-DojoTextFile -Path $path -Text (ConvertTo-DojoJson -Value $meta -KeyOrder $script:DojoMetaKeyOrder)
    } -ArgumentList $file, $Values
}

function Invoke-DojoPrivate {
    param(
        [Parameter(Mandatory = $true)]
        [scriptblock]$ScriptBlock,

        [object[]]$ArgumentList = @()
    )

    $module = Get-Module -Name PSDojo
    & $module $ScriptBlock @ArgumentList
}

function Get-DojoHostText {
    param(
        [Parameter(Mandatory = $true)]
        [scriptblock]$ScriptBlock
    )

    $lines = & $ScriptBlock 6>&1 3>&1 | ForEach-Object { [string]$_ }
    return (@($lines) -join [Environment]::NewLine)
}
