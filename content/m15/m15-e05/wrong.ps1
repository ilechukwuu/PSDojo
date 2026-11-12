$Start = [datetime]'2026-03-14T22:00:00'
$End = [datetime]'2026-03-15T03:30:00'

# Runtime of the nightly backup

$Duration = $End - $Start
$Minutes = $Duration.Minutes
$Hours = $Duration.Hours
