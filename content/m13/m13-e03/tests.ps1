param($SolutionPath)

Describe 'Inventory export for the file servers' {
    BeforeAll {
        . $SolutionPath
    }

    It 'Servers is a list of three names' {
        @($Servers).Count | Should -Be 3 -Because 'the text is separated by semicolons, so -split needs the separator ;'
        @($Servers)[1] | Should -Be 'FS-02'
    }

    It 'ServerLine joins the names with comma and space' {
        $ServerLine | Should -Be 'FS-01, FS-02, FS-03' -Because '-join puts the separator between the elements of the list'
    }

    It 'DriveNumbers is the range 1 to 4' {
        @($DriveNumbers) -join ' ' | Should -Be '1 2 3 4' -Because '1..4 creates the numbers from 1 to 4'
    }

    It 'IsNumber says that the text is not an int' {
        ($IsNumber -is [bool]) | Should -BeTrue -Because '-is answers with $true or $false'
        $IsNumber | Should -BeFalse -Because 'the value is still text, even though it looks like a number'
    }

    It 'Size is the converted number' {
        ($Size -is [int]) | Should -BeTrue -Because '-as [int] converts the text to a whole number'
        $Size | Should -Be 500
    }

    It 'Broken is empty because the text is not a number' {
        $Broken | Should -BeNullOrEmpty -Because '-as returns $null instead of an error when the conversion is impossible'
    }
}
