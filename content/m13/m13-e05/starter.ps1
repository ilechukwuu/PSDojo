param($Status = 'Running')

# Does this service state need attention?

$NeedsAttention = $Status -eq 'Stopped' -or $Status -eq 'Paused' -or $Status -eq 'StartPending' -or $Status -eq 'StopPending'
