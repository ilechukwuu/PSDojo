function ConvertTo-DojoJsonString {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [string]$Text
    )

    $builder = New-Object -TypeName System.Text.StringBuilder
    [void]$builder.Append('"')
    foreach ($character in $Text.ToCharArray()) {
        $code = [int]$character
        if ($character -eq '"') {
            [void]$builder.Append('\"')
        }
        elseif ($character -eq '\') {
            [void]$builder.Append('\\')
        }
        elseif ($code -eq 10) {
            [void]$builder.Append('\n')
        }
        elseif ($code -eq 13) {
            [void]$builder.Append('\r')
        }
        elseif ($code -eq 9) {
            [void]$builder.Append('\t')
        }
        elseif ($code -lt 32) {
            [void]$builder.Append(('\u{0:x4}' -f $code))
        }
        else {
            [void]$builder.Append($character)
        }
    }
    [void]$builder.Append('"')
    return $builder.ToString()
}

function ConvertTo-DojoJson {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter()]
        [AllowNull()]
        $Value,

        [Parameter()]
        [int]$Depth = 0,

        [Parameter()]
        [string[]]$KeyOrder = @()
    )

    $indent = '  ' * $Depth
    $inner = '  ' * ($Depth + 1)
    $newLine = "`n"

    if ($null -eq $Value) {
        return 'null'
    }
    if ($Value -is [bool]) {
        return $Value.ToString().ToLower()
    }
    if ($Value -is [string]) {
        return (ConvertTo-DojoJsonString -Text $Value)
    }
    if ($Value -is [System.ValueType]) {
        return ([System.Convert]::ToString($Value, [cultureinfo]::InvariantCulture))
    }
    if ($Value -is [System.Collections.IDictionary]) {
        $keys = New-Object -TypeName System.Collections.ArrayList
        foreach ($key in $KeyOrder) {
            if ($Value.Contains($key)) {
                [void]$keys.Add($key)
            }
        }
        foreach ($key in ($Value.Keys | Sort-Object)) {
            if (-not $keys.Contains([string]$key)) {
                [void]$keys.Add([string]$key)
            }
        }
        if ($keys.Count -eq 0) {
            return '{}'
        }
        $parts = foreach ($key in $keys) {
            $inner + (ConvertTo-DojoJsonString -Text $key) + ': ' + (ConvertTo-DojoJson -Value $Value[$key] -Depth ($Depth + 1) -KeyOrder $KeyOrder)
        }
        return '{' + $newLine + ($parts -join (',' + $newLine)) + $newLine + $indent + '}'
    }
    if ($Value -is [System.Collections.IEnumerable]) {
        $items = @($Value)
        if ($items.Count -eq 0) {
            return '[]'
        }
        $simple = @($items | Where-Object { $_ -is [string] -or $_ -is [System.ValueType] }).Count -eq $items.Count
        if ($simple) {
            $parts = foreach ($item in $items) {
                ConvertTo-DojoJson -Value $item -Depth ($Depth + 1)
            }
            return '[' + ($parts -join ', ') + ']'
        }
        $parts = foreach ($item in $items) {
            $inner + (ConvertTo-DojoJson -Value $item -Depth ($Depth + 1) -KeyOrder $KeyOrder)
        }
        return '[' + $newLine + ($parts -join (',' + $newLine)) + $newLine + $indent + ']'
    }
    return (ConvertTo-DojoJsonString -Text ([string]$Value))
}
