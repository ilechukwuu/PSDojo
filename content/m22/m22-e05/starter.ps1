param($Root = '.', [switch]$WhatIf)

# Nightly cleanup of temporary import files, with a dry run

$Candidates = $null

# Step 2: delete each file in $Candidates and hand -WhatIf on
