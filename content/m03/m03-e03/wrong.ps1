# Broken umlauts in a report from FS-02: which cmdlets control the encoding?

$EncodingCommands = Get-Command -Name Encoding -CommandType Cmdlet
$ManagementCommands = Get-Command -Module Microsoft.PowerShell.Management
$ContentParameters = (Get-Command -Name Get-Content).Parameters.Keys
$ContentModule = (Get-Command -Name Get-Content).ModuleName
