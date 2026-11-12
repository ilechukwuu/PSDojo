param($SolutionPath)

Describe 'Facts about the new file share' {
    BeforeAll {
        . $SolutionPath
        function Get-TypeName {
            param($Value)
            if ($null -eq $Value) { return 'nothing' }
            return $Value.GetType().Name
        }
    }

    It 'Server is the text FS-02' {
        Get-TypeName -Value $Server | Should -Be 'String' -Because 'text is written in quotes'
        $Server | Should -Be 'FS-02'
    }

    It 'Port is a whole number' {
        Get-TypeName -Value $Port | Should -Be 'Int32' -Because 'a number is written without quotes, in quotes it is text'
        $Port | Should -Be 445
    }

    It 'UsedPercent is a decimal number' {
        Get-TypeName -Value $UsedPercent | Should -Be 'Double' -Because 'a number with a decimal point is a Double'
        $UsedPercent | Should -Be 81.5
    }

    It 'IsProduction is a boolean' {
        Get-TypeName -Value $IsProduction | Should -Be 'Boolean' -Because 'the boolean value is $true, not the text true'
        $IsProduction | Should -BeTrue
    }

    It 'CheckedAt is a date' {
        Get-TypeName -Value $CheckedAt | Should -Be 'DateTime' -Because 'Get-Date returns a date object'
    }

    It 'PercentType is the type name of UsedPercent' {
        $PercentType | Should -Be 'Double' -Because 'GetType().Name returns the name of the type'
    }
}
