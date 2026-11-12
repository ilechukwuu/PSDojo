param($Folder = '.')

# Volumes that are running low, from CSV to CSV

$Rows = Import-Csv -Path "$Folder/disks.csv" -Delimiter ';'
$Low = $Rows | Where-Object { $_.FreeGB -lt 20 }

$Low | Export-Csv -Path "$Folder/low.csv" -Delimiter ';' -NoTypeInformation -Encoding UTF8
