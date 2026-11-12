# Limits of the disk monitoring per drive

$Limits = @{ 'C:' = 10; 'D:' = 50 }

$Limits['E:'] = 20
$Limits['C:'] = 15

$LimitD = $Limits['D:']
$HasF = $Limits.ContainsKey('F:')
$DriveCount = $Limits.Count
