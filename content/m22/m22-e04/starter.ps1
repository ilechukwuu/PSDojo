param($Root = '.')

# Before the update: back up the configuration, move the logs away. Three mistakes.

Copy-Item -Path "$Root/config" -Destination "$Root/backup"

$Logs = Get-ChildItem -Path "$Root/logs" -Filter '.log'

foreach ($Log in $Logs) {
    Move-Item -Path $Log.FullName -Destination "$Root/archive"
}
