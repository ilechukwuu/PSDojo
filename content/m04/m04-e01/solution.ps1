# Taking stock of a server: what can this session reach?

$Providers = Get-PSProvider
$Drives = Get-PSDrive
$DiskDrives = Get-PSDrive -PSProvider FileSystem
$EnvDrive = Get-PSDrive -Name Env
