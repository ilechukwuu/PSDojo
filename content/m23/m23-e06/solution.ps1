# Names of report files older than a number of days
param(
    [string]$Path = 'D:\Reports',
    [int]$Days = 30
)

$Limit = (Get-Date).AddDays(-$Days)

Get-ChildItem -Path $Path -File |
    Where-Object { $_.LastWriteTime -lt $Limit } |
    ForEach-Object { $_.Name }
