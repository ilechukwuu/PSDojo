# Rows of the weekly disk report

$Row1 = [pscustomobject]@{ Server = 'FS-01'; Drive = 'D:'; FreeGB = 120 }
$Row2 = [pscustomobject]@{ Server = 'FS-02'; Drive = 'D:'; FreeGB = 8 }
$Report = $Row1, $Row2
$Low = $Report | Where-Object { $_.FreeGB -lt 20 }
$Servers = $Report.Server
