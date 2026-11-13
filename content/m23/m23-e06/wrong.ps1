# Names of report files older than a number of days
param(
    [string]$Path = 'D:\Reports',
    [int]$Days = 30
)

$global:ReportLimit = (Get-Date).AddDays(-$Days)

Get-ChildItem -Path $Path -File |
    Where-Object { $_.LastWriteTime -lt $global:ReportLimit } |
    ForEach-Object { $_.Name }
