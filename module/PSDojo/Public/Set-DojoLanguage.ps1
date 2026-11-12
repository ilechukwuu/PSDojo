function Set-DojoLanguage {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateSet('de', 'en')]
        [string]$Language
    )

    $progress = Read-DojoProgress
    if ($PSCmdlet.ShouldProcess((Get-DojoProgressPath), "Set language to $Language")) {
        $progress['language'] = $Language
        $script:DojoLanguageOverride = $Language
        Save-DojoProgress -Progress $progress
        Write-DojoLine -Text (Get-DojoString -Key 'LanguageSet')
    }
}
