param($SolutionPath)

Describe 'Limits of the disk monitoring' {
    BeforeAll {
        . $SolutionPath
    }

    It 'Limits is a hashtable' {
        ($Limits -is [System.Collections.IDictionary]) | Should -BeTrue -Because 'a hashtable is written as @{ key = value }'
    }

    It 'The limit for C: was changed to 15' {
        $Limits['C:'] | Should -Be 15 -Because 'assigning to an existing key replaces its value'
    }

    It 'E: was added with the value 20' {
        $Limits['E:'] | Should -Be 20 -Because 'assigning to a new key adds the pair'
    }

    It 'LimitD is the limit for D:' {
        $LimitD | Should -Be 50 -Because 'a value is read with its key in square brackets'
    }

    It 'HasF says that F: is not in the table' {
        ($HasF -is [bool]) | Should -BeTrue -Because 'ContainsKey answers with $true or $false'
        $HasF | Should -BeFalse
    }

    It 'DriveCount is the number of pairs' {
        $DriveCount | Should -Be 3 -Because 'Count is the number of key and value pairs'
    }
}
