param($SolutionPath)

Describe 'Draft of the weekly server report' {
    BeforeAll {
        . $SolutionPath
        $allBoolean = @($Works1, $Works2, $Works3, $Works4, $Works5 | Where-Object { $_ -is [bool] }).Count -eq 5
    }

    It 'Every answer is true or false' {
        $allBoolean | Should -BeTrue -Because 'each answer is $true or $false'
    }

    It 'Works1: filter first, format last' {
        $Works1 | Should -BeTrue -Because 'the filter runs on the service objects and the format is the last command'
    }

    It 'Works2: a filter after the format finds nothing' {
        $Works2 | Should -BeFalse -Because 'after Format-Table there are layout instructions without a property Status'
    }

    It 'Works3: Export-Csv after the format exports layout instructions' {
        $Works3 | Should -BeFalse -Because 'Export-Csv needs data objects. After Format-Table it writes the layout instructions into the file'
    }

    It 'Works4: Out-File understands formatted output' {
        $Works4 | Should -BeTrue -Because 'the Out- cmdlets are the only ones that understand what a Format- cmdlet returns'
    }

    It 'Works5: a sort after the format sorts nothing' {
        $Works5 | Should -BeFalse -Because 'after Format-List there is no property Name left to sort by'
    }
}
