# Names of report files older than a number of days

$global:ReportPath = 'D:\Reports'
$global:ReportDays = 30
$global:ReportLimit = (Get-Date).AddDays(-$global:ReportDays)

Get-ChildItem -Path $global:ReportPath -File |
    Where-Object { $_.LastWriteTime -lt $global:ReportLimit } |
    ForEach-Object { $_.Name }
