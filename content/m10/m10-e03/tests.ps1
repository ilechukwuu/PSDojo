param($SolutionPath)

Describe 'State of the Nordwind services for the ticket' {
    BeforeAll {
        . (Join-Path -Path $PSScriptRoot -ChildPath '../../_shared/Stubs.ps1')
        . (Join-Path -Path $PSScriptRoot -ChildPath '../../_shared/Fixtures.ps1')
        Mock Get-Service { Get-DojoService -Name $Name }
        $folder = Join-Path -Path $TestDrive -ChildPath 'ticket'
        $null = New-Item -Path $folder -ItemType Directory -Force
        . $SolutionPath -ReportFolder $folder
        $file = Join-Path -Path $folder -ChildPath 'nordwind.txt'
        $fileText = if (Test-Path -LiteralPath $file) { Get-Content -LiteralPath $file -Raw -Encoding UTF8 } else { '' }
    }

    It 'The file nordwind.txt holds the table' {
        $fileText | Should -Match 'Name\s+Status\s+StartType' -Because 'the formatted table is written with Out-File -FilePath'
        $fileText | Should -Match 'NordwindSync\s+Stopped\s+Automatic'
    }

    It 'The file holds the Nordwind services only' {
        $fileText | Should -Not -Match 'Spooler' -Because 'Get-Service -Name Nordwind* limits the list to the three services'
    }

    It 'TicketText is the table as one text' {
        $type = if ($null -eq $TicketText) { 'nothing' } else { $TicketText.GetType().Name }
        $type | Should -Be 'String' -Because 'Out-String turns the formatted output into text, without it the variable holds layout instructions'
        $TicketText | Should -Match 'NordwindApi\s+Running\s+Automatic'
    }
}
