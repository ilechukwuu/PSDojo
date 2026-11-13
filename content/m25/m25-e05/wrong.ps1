# Three lines for the morning mail, built by one function

function Format-ServerLine {
    $State = if ($FreeGB -lt 50) { 'LOW' } else { 'ok' }
    '{0}: {1} GB free ({2})' -f $Name, $FreeGB, $State
}

$Lines = foreach ($Entry in @(@('FS-01', 210), @('FS-02', 9), @('WEB-01', 61))) {
    $Name = $Entry[0]
    $FreeGB = $Entry[1]
    Format-ServerLine
}
