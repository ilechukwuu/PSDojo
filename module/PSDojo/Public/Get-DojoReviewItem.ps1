function Get-DojoReviewItem {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [ValidateSet('draft', 'reviewed', 'approved')]
        [string[]]$Status = @('draft', 'reviewed'),

        [Parameter()]
        [string]$Module
    )

    foreach ($exercise in (Get-DojoExerciseList -IncludeUnapproved)) {
        if ($Status -notcontains $exercise.Status) {
            continue
        }
        if ($Module -and $exercise.Module -ne $Module) {
            continue
        }
        $review = $exercise.Review
        $reviewer = ''
        $action = ''
        $comment = ''
        $stamp = ''
        if ($review -is [System.Collections.IDictionary]) {
            $reviewer = [string]$review['reviewer']
            $action = [string]$review['action']
            $comment = [string]$review['comment']
            $date = ConvertTo-DojoDate -Value $review['timestamp']
            if ($date) {
                $stamp = $date.ToLocalTime().ToString('yyyy-MM-dd HH:mm')
            }
        }
        [pscustomobject]@{
            PSTypeName  = 'PSDojo.ReviewItem'
            Id          = $exercise.Id
            Module      = $exercise.Module
            Type        = $exercise.Type
            Status      = $exercise.Status
            LastAction  = $action
            Reviewer    = $reviewer
            Timestamp   = $stamp
            Comment     = $comment
            Placeholder = $exercise.Placeholder
            Title       = Get-DojoLocalText -Table $exercise.Title
        }
    }
}
