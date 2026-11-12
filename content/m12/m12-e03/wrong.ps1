$UsedText = '410'
$TotalText = '500'
$DateText = '2026-03-14'

# One row of the capacity file for FS-02, converted

$UsedGB = $UsedText
$TotalGB = $TotalText
$UsedPercent = [math]::Round($UsedGB / $TotalGB * 100, 1)
$MeasuredAt = [datetime]$DateText
$NextCheck = $MeasuredAt.AddDays(7)
