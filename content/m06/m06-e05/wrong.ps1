$UsedPercentC = 81.3749
$UsedPercentD = 93.8215
$FileName = 'usage-2026-03.csv'

# Calculated values for the monthly usage report

$RoundedC = [math]::Round($UsedPercentC)
$Highest = [math]::Max($UsedPercentC, $UsedPercentD)
$Extension = [System.IO.Path]::GetExtension($FileName)
$Today = [datetime]::Today
