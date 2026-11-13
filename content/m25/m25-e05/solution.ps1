# Three lines for the morning mail, built by one function

function Format-ServerLine {
    param(
        [string]$Name,
        [int]$FreeGB
    )

    $State = if ($FreeGB -lt 50) { 'LOW' } else { 'ok' }
    '{0}: {1} GB free ({2})' -f $Name, $FreeGB, $State
}

$Lines = @(
    Format-ServerLine -Name 'FS-01' -FreeGB 210
    Format-ServerLine -Name 'FS-02' -FreeGB 9
    Format-ServerLine -Name 'WEB-01' -FreeGB 61
)
