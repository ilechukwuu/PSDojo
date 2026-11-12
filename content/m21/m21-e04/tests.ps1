param($SolutionPath)

Describe 'Server inventory from XML' {
    BeforeAll {
        $folder = Join-Path -Path $TestDrive -ChildPath 'assets'
        $null = New-Item -Path $folder -ItemType Directory -Force
        Set-Content -LiteralPath (Join-Path -Path $folder -ChildPath 'inventory.xml') -Encoding UTF8 -Value @(
            '<inventory>'
            '  <server name="FS-01" site="Kiel"><ramGB>32</ramGB></server>'
            '  <server name="FS-02" site="Hamburg"><ramGB>64</ramGB></server>'
            '  <server name="PRN-01" site="Hamburg"><ramGB>16</ramGB></server>'
            '</inventory>'
        )
        . $SolutionPath -Folder $folder
    }

    It 'Doc is an XML document' {
        ($Doc -is [xml]) | Should -BeTrue -Because '[xml] in front of the file content turns it into a document'
    }

    It 'Servers holds the three server elements' {
        @($Servers).Count | Should -Be 3 -Because 'several elements with the same name come back as a list'
    }

    It 'Names holds the attribute name of every server' {
        @($Names) -join ', ' | Should -Be 'FS-01, FS-02, PRN-01' -Because 'an attribute is read like a property'
    }

    It 'HamburgNames holds the servers of the site Hamburg' {
        @($HamburgNames) -join ', ' | Should -Be 'FS-02, PRN-01' -Because 'the list of elements can be filtered with Where-Object'
    }

    It 'TotalRam is the sum as a number' {
        $TotalRam | Should -Be 112 -Because 'XML values are text. Joined with + they become 326416, Measure-Object -Sum adds them as numbers'
    }
}
