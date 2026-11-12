$Start = [datetime]'2026-03-14T22:00:00'
$End = [datetime]'2026-03-15T03:30:00'

# Runtime of the nightly backup, converted by hand

$Ticks = $End.Ticks - $Start.Ticks
$Minutes = $Ticks / 10000000 / 60
$Hours = $Minutes / 60
