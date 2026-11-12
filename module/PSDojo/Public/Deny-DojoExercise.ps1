function Deny-DojoExercise {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Id,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Comment,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Reviewer = [Environment]::UserName
    )

    $exercise = Get-DojoReviewExercise -Id $Id
    if (-not $exercise) {
        return
    }
    if ([string]::IsNullOrWhiteSpace($Comment)) {
        Write-Error -Message (Get-DojoString -Key 'ReviewCommentNeeded') -Category InvalidArgument
        return
    }
    $entry = Set-DojoReviewState -Exercise $exercise -Action reject -NewStatus 'draft' -Reviewer $Reviewer -Comment $Comment
    if ($entry) {
        Write-DojoLine -Text (Get-DojoString -Key 'ReviewDone' -Values $Id, $entry['from'], $entry['to'], $Reviewer)
        Get-DojoReviewItem -Status 'draft' | Where-Object { $_.Id -eq $Id }
    }
}
