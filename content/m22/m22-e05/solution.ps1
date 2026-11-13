param($Root = '.', [switch]$WhatIf)

# Nightly cleanup of temporary import files, with a dry run

$Limit = (Get-Date).AddDays(-7)

$Candidates = Get-ChildItem -Path $Root -Filter '*.tmp' -File -Recurse |
    Where-Object { $_.LastWriteTime -lt $Limit }

foreach ($File in $Candidates) {
    Remove-Item -LiteralPath $File.FullName -WhatIf:$WhatIf
}
