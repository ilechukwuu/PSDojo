param($SolutionPath)

Describe 'What check.ps1 sends where' {
    BeforeAll {
        . $SolutionPath
    }

    It 'CapturedCount is the number of items in the result' {
        $CapturedCount | Should -Be 2 -Because 'a variable captures only stream 1. Write-Host and Write-Warning go past it'
    }

    It 'CapturedWithWarnings counts the merged warning too' {
        $CapturedWithWarnings | Should -Be 3 -Because '3>&1 merges the warning stream into the result, the text of Write-Host still goes to the screen'
    }

    It 'WarningStream is the number of the warning stream' {
        $WarningStream | Should -Be 3 -Because 'the streams are numbered: 1 success, 2 error, 3 warning, 4 verbose'
    }

    It 'LoggedWord is the first word of the text in the file' {
        ([string]$LoggedWord).Trim() | Should -Be 'Disk' -Because '3> redirects the warning stream, and only Write-Warning wrote to it'
    }
}
