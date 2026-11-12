param($SolutionPath)

Describe 'Log report for APP-01' {
    BeforeAll {
        $root = Join-Path -Path $TestDrive -ChildPath 'app01'
        $null = New-Item -Path (Join-Path -Path $root -ChildPath 'iis') -ItemType Directory -Force
        Set-Content -LiteralPath (Join-Path -Path $root -ChildPath 'app.log') -Value 'x'
        Set-Content -LiteralPath (Join-Path -Path $root -ChildPath 'readme.txt') -Value 'x'
        Set-Content -LiteralPath (Join-Path -Path $root -ChildPath 'iis/u_ex260314.log') -Value 'x'
        . $SolutionPath -Root $root 2>$null
    }

    It 'Logs holds the two log files including the subfolder' {
        (@($Logs).Name | Sort-Object) -join ', ' | Should -Be 'app.log, u_ex260314.log' -Because 'the hashtable must be passed with @Params, and its keys must be real parameter names such as Recurse'
    }

    It 'Summary is an object with two properties' {
        ($Summary -is [System.Management.Automation.PSCustomObject]) | Should -BeTrue -Because 'a row of data needs [pscustomobject] in front of the hashtable'
        $Summary.LogCount | Should -Be 2
    }

    It 'SummaryFolder is the value of the property Folder' {
        $SummaryFolder | Should -Be $root -Because 'Select-Object -ExpandProperty reads a property of the object'
    }
}
