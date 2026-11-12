param($SolutionPath)

Describe 'Services on PRN-01' {
    BeforeAll {
        . $SolutionPath
    }

    It 'GroupCount is the number of groups' {
        $GroupCount | Should -Be 3 -Because 'Measure-Object counts what arrives, and after Group-Object those are groups, one per start type'
    }

    It 'LargestGroup is the status that occurs most often' {
        ([string]$LargestGroup).Trim() | Should -Be 'Stopped' -Because 'the groups are sorted by Count, and Name of a group is the value it stands for'
    }

    It 'FirstName is the first service after sorting by two properties' {
        ([string]$FirstName).Trim() | Should -Be 'Spooler' -Because 'the list is sorted by start type first and by name within the same start type'
    }

    It 'UniqueCount is the number of distinct status values' {
        $UniqueCount | Should -Be 2 -Because 'Sort-Object -Unique leaves each value once, and there are two status values'
    }
}
