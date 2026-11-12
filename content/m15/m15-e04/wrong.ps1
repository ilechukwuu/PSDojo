$Today = [datetime]'2026-03-14'
$ExpiryText = '03.04.2026'

# Certificate check for WEB-01

$Expires = [datetime]$ExpiryText
$WarnFrom = $Expires.AddDays(-30)
$ShouldWarn = $Today -ge $WarnFrom
