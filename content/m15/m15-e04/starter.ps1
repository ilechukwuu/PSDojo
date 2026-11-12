$Today = [datetime]'2026-03-14'
$ExpiryText = '03.04.2026'

# Certificate check for WEB-01. Three date mistakes.

$Expires = [datetime]$ExpiryText
$WarnFrom = $Expires.AddDays(30)
$ShouldWarn = '14.03.2026' -ge $WarnFrom.ToString('dd.MM.yyyy')
