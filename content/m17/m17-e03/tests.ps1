param($SolutionPath)

Describe 'Rows of the weekly disk report' {
    BeforeAll {
        . $SolutionPath
    }

    It 'Row1 is an object with three properties in order' {
        ($Row1 -is [System.Management.Automation.PSCustomObject]) | Should -BeTrue -Because 'a report row is an object: [pscustomobject] in front of the hashtable. A plain hashtable is a container, not a row'
        $Row1.PSObject.Properties.Name -join ', ' | Should -Be 'Server, Drive, FreeGB' -Because 'the properties keep the order in which they were written'
    }

    It 'Row2 holds the values for FS-02' {
        $Row2.Server | Should -Be 'FS-02'
        $Row2.FreeGB | Should -Be 8
    }

    It 'Report holds both rows' {
        @($Report).Count | Should -Be 2 -Because 'the two objects are joined to an array with a comma'
    }

    It 'Low holds the row with little free space' {
        @($Low).Server -join ', ' | Should -Be 'FS-02' -Because 'Where-Object filters custom objects like any others'
    }

    It 'Servers holds the names as text' {
        @($Servers) -join ', ' | Should -Be 'FS-01, FS-02' -Because 'reading a property on the array returns it from every row'
    }
}
