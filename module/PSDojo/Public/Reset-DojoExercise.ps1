function Reset-DojoExercise {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0)]
        [string]$Id
    )

    $progress = Read-DojoProgress
    $state = Resolve-DojoExercise -Progress $progress -Id $Id
    if (-not $state) {
        return
    }
    $exercise = $state.Exercise
    $target = Get-DojoLearnerFile -Exercise $exercise
    if ($PSCmdlet.ShouldProcess($target, 'Restore starter file')) {
        $folder = Split-Path -Path $target -Parent
        if (-not (Test-Path -LiteralPath $folder)) {
            [void](New-Item -Path $folder -ItemType Directory -Force)
        }
        Copy-Item -LiteralPath (Join-Path -Path $exercise.Path -ChildPath 'starter.ps1') -Destination $target -Force
        Write-DojoLine -Text (Get-DojoString -Key 'ResetDone' -Values $exercise.Id, $target)
    }
}
