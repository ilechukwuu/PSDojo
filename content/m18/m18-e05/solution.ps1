param($ExitCode = 0)

# Exit code of the backup tool as text

$Text = switch ($ExitCode) {
    0       { 'Backup finished' }
    1       { 'Finished with warnings' }
    2       { 'Target not reachable' }
    5       { 'Access denied' }
    default { 'Unknown exit code' }
}
