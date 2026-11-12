param($SolutionPath)

Describe 'Facts from one line of the monitoring log' {
    BeforeAll {
        . $SolutionPath
        $errorLine = @{ IsError = $IsError; Server = $Server; Percent = $Percent }

        . $SolutionPath -LogLine '2026-03-14 22:10:00 INFO Disk E: on FS-117 is 8 percent full'
        $infoLine = @{ IsError = $IsError; Server = $Server; Percent = $Percent }

        . $SolutionPath -LogLine '2026-03-14 22:11:00 INFO Backup finished'
        $otherLine = @{ IsError = $IsError; Server = $Server; Percent = $Percent }
    }

    It 'IsError says whether the line contains ERROR' {
        $errorLine.IsError | Should -BeTrue -Because '-match answers true when the word is found'
        $infoLine.IsError | Should -BeFalse -Because 'an INFO line does not contain the word ERROR'
    }

    It 'Server is the captured server name only' {
        $errorLine.Server | Should -BeExactly 'FS-02' -Because 'the captured part is $Matches[1]. $Matches[0] is the whole match including the word on'
        $infoLine.Server | Should -BeExactly 'FS-117' -Because '\d+ matches one or more digits'
    }

    It 'Percent is the number in front of the word percent' {
        $errorLine.Percent | Should -Be 91 -Because '(\d+) percent captures the digits'
        ($errorLine.Percent -is [int]) | Should -BeTrue -Because 'a captured part is text and has to be converted with [int]'
        $infoLine.Percent | Should -Be 8
    }

    It 'A line without these parts leaves the variables empty' {
        $otherLine.Server | Should -BeNullOrEmpty -Because '$Matches keeps old values when a match fails, so it is only read inside the if'
        $otherLine.Percent | Should -BeNullOrEmpty -Because '$Matches keeps old values when a match fails, so it is only read inside the if'
    }
}
