param($LogFile = 'backup.log')

# Search the backup log of FS-02

$Errors = Select-String -Path $LogFile -Pattern 'ERROR'
$ErrorCount = @($Errors).Count
$FirstErrorLine = @($Errors)[0].LineNumber
$ErrorTexts = @($Errors).Line
$PathHits = Select-String -Path $LogFile -Pattern 'D:.Backup.full.bak'
