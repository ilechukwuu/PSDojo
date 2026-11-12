param($Status = 'Running')

# Does this service state need attention?

$ProblemStates = 'Stopped', 'Paused', 'StartPending', 'StopPending'
$NeedsAttention = $Status -in $ProblemStates
