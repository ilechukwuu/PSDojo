param($Root = '.')

# Log search for APP-01. One very long line.

$Logs = Get-ChildItem -Path $Root -Filter '*.log' -Recurse -File -ErrorAction Stop
