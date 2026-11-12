param($ReportFolder = '.')

# State of the Nordwind services for the ticket

Get-Service -Name Nordwind* |
    Format-Table -Property Name, Status, StartType |
    Out-File -FilePath "$ReportFolder/nordwind.txt" -Encoding utf8 -Width 200

$TicketText = Get-Service -Name Nordwind* |
    Format-Table -Property Name, Status, StartType
