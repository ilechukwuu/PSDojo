param($Status = 'Running')

# Does this service state need attention?

$ProblemStates = 'Stopped', 'Paused', 'StartPending'
$NeedsAttention = $Status -in $ProblemStates
