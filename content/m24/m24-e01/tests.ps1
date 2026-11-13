param($SolutionPath)

Describe 'One conversion from bytes to gigabytes' {
    BeforeAll {
        . $SolutionPath
        $isBlock = $ToGB -is [scriptblock]
        $probe = $null
        if ($isBlock) {
            $Bytes = $null
            $probe = & $ToGB -Bytes 1610612736
        }
    }

    It 'ToGB is a script block' {
        $isBlock | Should -BeTrue -Because 'code in braces is stored without being run'
    }

    It 'The block converts the value it is given' {
        $probe | Should -Be 1.5 -Because 'the block needs its own parameter with param($Bytes). A block that reads a variable from outside cannot be given a value'
    }

    It 'Size is the result for 50 GB' {
        $Size | Should -Be 50 -Because 'the call operator & runs the block with the value behind it'
    }

    It 'Sizes holds one result per volume' {
        @($Sizes) -join ' | ' | Should -Be '10 | 1.5 | 250' -Because 'the block is invoked once for every value in $VolumeBytes'
    }
}
