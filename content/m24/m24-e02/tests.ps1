param($SolutionPath)

Describe 'One rule for both lists' {
    BeforeAll {
        . $SolutionPath
        $probeObjects = @(
            [pscustomobject]@{ Server = 'TS-03'; Drive = 'C:'; FreePercent = 14 }
            [pscustomobject]@{ Server = 'TS-03'; Drive = 'D:'; FreePercent = 15 }
        )
        $probeCount = -1
        if ($IsLow -is [scriptblock]) {
            $probeCount = @($probeObjects | Where-Object -FilterScript $IsLow).Count
        }
    }

    It 'IsLow is a script block that tests the current object' {
        ($IsLow -is [scriptblock]) | Should -BeTrue -Because 'the rule is stored as code in braces'
        $probeCount | Should -Be 1 -Because 'the block compares $_.FreePercent with 15, and 15 itself is not below 15'
    }

    It 'LowFile holds the low volume of the file servers' {
        @($LowFile).Server -join ', ' | Should -Be 'FS-02' -Because 'the variable is passed directly to -FilterScript. Wrapped in another pair of braces the stored block is only output, which counts as true for every object'
    }

    It 'LowApp holds the low volume of the application servers' {
        @($LowApp).Server -join ', ' | Should -Be 'APP-01' -Because 'the same block filters the second list'
    }

    It 'Labels holds one text per low volume' {
        ($ToLabel -is [scriptblock]) | Should -BeTrue -Because 'the label rule is stored as a script block too'
        @($Labels) -join ' | ' | Should -Be 'FS-02 D: | APP-01 C:' -Because 'ForEach-Object -Process runs the block once per object'
    }
}
