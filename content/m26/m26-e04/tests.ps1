param($SolutionPath)

Describe 'Description of a restore job' {
    BeforeAll {
        . $SolutionPath
        $tape = $null
        $tapeError = ''
        try { $tape = @(Get-RestoreJob -ComputerName 'FS-01' -Source 'Tape') } catch { $tapeError = $_.Exception.Message }
        $loud = @()
        try { $loud = @(Get-RestoreJob -ComputerName 'FS-01' -Source 'Cloud' -Verbose 4>&1) } catch { $loud = @() }
        $messages = @($loud | Where-Object { $_ -is [System.Management.Automation.VerboseRecord] })
    }

    It 'Tape is an accepted source' {
        $tapeError | Should -Be '' -Because 'ValidateSet needs each value as a text of its own. One text with commas in it is a single value'
    }

    It 'The function returns exactly one object' {
        @($tape).Count | Should -Be 1 -Because 'a bare text in the body is output and lands in the result. Status messages belong in Write-Verbose'
        $tape[0].Source | Should -Be 'Tape'
    }

    It 'The status text appears with -Verbose' {
        $messages.Count | Should -Be 1 -Because 'Write-Verbose writes to the verbose stream, which -Verbose switches on'
        $messages[0].Message | Should -Be 'Preparing restore for FS-01'
    }

    It 'A source outside the list is still rejected' {
        { Get-RestoreJob -ComputerName 'FS-01' -Source 'Usb' } | Should -Throw -Because 'the validation must stay in place'
    }
}
