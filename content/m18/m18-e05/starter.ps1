param($ExitCode = 0)

# Exit code of the backup tool as text. One long elseif chain.

if ($ExitCode -eq 0) {
    $Text = 'Backup finished'
}
elseif ($ExitCode -eq 1) {
    $Text = 'Finished with warnings'
}
elseif ($ExitCode -eq 2) {
    $Text = 'Target not reachable'
}
elseif ($ExitCode -eq 5) {
    $Text = 'Access denied'
}
else {
    $Text = 'Unknown exit code'
}
