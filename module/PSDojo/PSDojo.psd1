@{
    RootModule        = 'PSDojo.psm1'
    ModuleVersion     = '0.1.0'
    GUID              = '5b0c4a52-7d0e-4c55-9a35-2f1f6a7f3c11'
    Author            = 'PSDojo'
    CompanyName       = 'Internal'
    Copyright         = 'Internal use only'
    Description       = 'In-house PowerShell training platform. Local front end.'
    PowerShellVersion = '5.1'
    FormatsToProcess  = @('PSDojo.Format.ps1xml')
    FunctionsToExport = @(
        'Start-Dojo'
        'Show-DojoLesson'
        'Test-Dojo'
        'Get-DojoHint'
        'Reset-DojoExercise'
        'Show-DojoProgress'
        'Export-DojoReport'
        'Get-DojoTeamReport'
        'Set-DojoLanguage'
        'Get-DojoReviewItem'
        'Show-DojoReviewItem'
        'Approve-DojoExercise'
        'Deny-DojoExercise'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
}
