param($SolutionPath)

Describe 'Volumes on FS-02' {
    BeforeAll {
        . $SolutionPath
    }

    It 'FirstResult is the volume with the least free space' {
        ([string]$FirstResult).Trim().TrimEnd(':') | Should -Be 'E' -Because 'Sort-Object sorts ascending by default, so the smallest value comes first'
    }

    It 'SecondResult is the larger of the first two volumes' {
        ([string]$SecondResult).Trim().TrimEnd(':') | Should -Be 'D' -Because 'Select-Object -First 2 lets only C and D through, and only those two are sorted'
    }

    It 'ThirdResult is the number of objects that reach Measure-Object' {
        $ThirdResult | Should -Be 3 -Because 'Measure-Object counts only what the command before it let through'
    }
}
