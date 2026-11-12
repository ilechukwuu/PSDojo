function Approve-DojoExercise {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Id,

        [Parameter()]
        [string]$Comment = '',

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Reviewer = [Environment]::UserName,

        [Parameter()]
        [switch]$AllowSameReviewer
    )

    $exercise = Get-DojoReviewExercise -Id $Id
    if (-not $exercise) {
        return
    }
    if ($exercise.Status -eq 'approved') {
        Write-Error -Message (Get-DojoString -Key 'ReviewAlreadyApproved' -Values $Id) -Category InvalidOperation
        return
    }
    $newStatus = 'reviewed'
    if ($exercise.Status -eq 'reviewed') {
        $newStatus = 'approved'
        $first = ''
        if ($exercise.Review -is [System.Collections.IDictionary]) {
            $first = [string]$exercise.Review['reviewer']
        }
        if ($first -eq $Reviewer -and -not $AllowSameReviewer) {
            Write-Error -Message (Get-DojoString -Key 'ReviewSameReviewer' -Values $Id, $Reviewer) -Category PermissionDenied
            return
        }
    }

    $failed = @(Test-DojoExerciseQuality -Exercise $exercise | Where-Object { -not $_.Ok })
    if ($failed.Count -gt 0) {
        $detail = ($failed | ForEach-Object { '{0}: {1}' -f $_.Check, $_.Detail }) -join ' | '
        Write-Error -Message (Get-DojoString -Key 'ReviewQualityFailed' -Values $Id, $detail) -Category InvalidData
        return
    }

    $entry = Set-DojoReviewState -Exercise $exercise -Action approve -NewStatus $newStatus -Reviewer $Reviewer -Comment $Comment
    if ($entry) {
        Write-DojoLine -Text (Get-DojoString -Key 'ReviewDone' -Values $Id, $entry['from'], $entry['to'], $Reviewer)
        Get-DojoReviewItem -Status $newStatus | Where-Object { $_.Id -eq $Id }
    }
}
