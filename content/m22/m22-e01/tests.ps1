param($SolutionPath)

Describe 'Output folder of the nightly report job' {
    BeforeAll {
        $newRoot = Join-Path -Path $TestDrive -ChildPath 'newserver'
        $oldRoot = Join-Path -Path $TestDrive -ChildPath 'oldserver'
        $null = New-Item -Path $newRoot -ItemType Directory -Force
        $null = New-Item -Path (Join-Path -Path $oldRoot -ChildPath 'Reports') -ItemType Directory -Force
        $oldReport = Join-Path -Path (Join-Path -Path $oldRoot -ChildPath 'Reports') -ChildPath 'january.csv'
        Set-Content -LiteralPath $oldReport -Value 'Server;FreeGB'

        . $SolutionPath -Root $newRoot 2>$null
        $newDir = $ReportDir
        $newExisted = $Existed
        $newStatus = $StatusFile

        $ReportDir = $null
        $Existed = $null
        $StatusFile = $null
        . $SolutionPath -Root $oldRoot 2>$null
        $oldExisted = $Existed
        $expectedDir = Join-Path -Path $newRoot -ChildPath 'Reports'
    }

    It 'ReportDir is the folder Reports below Root' {
        $newDir | Should -Be $expectedDir -Because 'Join-Path puts $Root and Reports together'
    }

    It 'Existed is false on the new server' {
        ($newExisted -is [bool]) | Should -BeTrue -Because 'Test-Path answers with $true or $false'
        $newExisted | Should -BeFalse -Because 'the question has to be asked before the folder is created. Asked afterwards the answer is always true'
    }

    It 'The folder was created on the new server' {
        Test-Path -LiteralPath $expectedDir -PathType Container | Should -BeTrue -Because 'New-Item -ItemType Directory creates the missing folder'
    }

    It 'Existed is true on the old server and the old report is still there' {
        $oldExisted | Should -BeTrue -Because 'on the old server the folder was already there'
        Test-Path -LiteralPath $oldReport | Should -BeTrue -Because 'an existing folder must keep its content'
    }

    It 'status.txt holds the text ready' {
        $newStatus | Should -Be (Join-Path -Path $expectedDir -ChildPath 'status.txt') -Because 'the file path is built with Join-Path from $ReportDir and status.txt'
        (Get-Content -LiteralPath (Join-Path -Path $expectedDir -ChildPath 'status.txt') -ErrorAction SilentlyContinue) -join '' | Should -Be 'ready' -Because 'Set-Content writes the text into the file'
    }
}
