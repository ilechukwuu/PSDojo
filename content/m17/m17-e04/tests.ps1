param($SolutionPath)

Describe 'Defaults of the deployment script' {
    BeforeAll {
        . $SolutionPath
    }

    It 'Result1: the change is visible through both names' {
        $Result1 | Should -Be 'Hamburg' -Because 'assigning a hashtable does not copy it, both variables refer to the same table'
    }

    It 'Result2: the added key counts for both' {
        $Result2 | Should -Be 3 -Because 'the key Owner was added to the one table that both variables refer to'
    }

    It 'Result3: a missing key returns nothing' {
        $Result3 | Should -BeNullOrEmpty -Because 'a key that does not exist returns $null and no error'
    }

    It 'Result4: a custom object keeps its order' {
        ([string]$Result4 -replace '\s', '') | Should -Be 'Server,Site,Port' -Because '[pscustomobject] keeps the properties in the order in which they were written'
    }
}
