param($SolutionPath)

Describe 'Three views of the services on APP-01' {
    BeforeAll {
        . (Join-Path -Path $PSScriptRoot -ChildPath '../../_shared/Stubs.ps1')
        . (Join-Path -Path $PSScriptRoot -ChildPath '../../_shared/Fixtures.ps1')
        Mock Get-Service {
            $visible = New-Object -TypeName System.Management.Automation.PSPropertySet -ArgumentList 'DefaultDisplayPropertySet', ([string[]]@('Name', 'Status', 'StartType'))
            foreach ($service in (Get-DojoService -Name $Name)) {
                $item = $service | Select-Object -Property Name, DisplayName, Status, StartType, @{ Name = 'MachineName'; Expression = { 'APP-01' } }
                $item | Add-Member -MemberType MemberSet -Name PSStandardMembers -Value ([System.Management.Automation.PSMemberInfo[]]@($visible)) -Force
                $item
            }
        }
        . $SolutionPath
        $tableText = ($Table | Out-String -Width 200)
        $listText = ($List | Out-String -Width 200)
        $wideText = ($Wide | Out-String -Width 200)
    }

    It 'Table shows the columns Name and Status only' {
        $tableText | Should -Match 'Name\s+Status' -Because 'Format-Table -Property Name, Status draws these two columns'
        $tableText | Should -Not -Match 'StartType' -Because 'only the two named properties are shown'
    }

    It 'List shows every property of Spooler' {
        $listText | Should -Match 'MachineName\s*:\s*APP-01' -Because 'Format-List -Property * shows every property, without it the default view hides some'
        $listText | Should -Not -Match 'WinRM' -Because 'the list is for the service Spooler only'
    }

    It 'Wide shows the names in three columns' {
        @($wideText -split "`r?`n" | Where-Object { $_ -match 'Spooler\s+LanmanServer\s+W32Time' }).Count | Should -Be 1 -Because 'Format-Wide -Property Name -Column 3 puts three names on each line'
    }
}
