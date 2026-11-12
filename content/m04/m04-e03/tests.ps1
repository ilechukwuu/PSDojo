param($SolutionPath)

Describe 'Audit of WEB-01' {
    BeforeAll {
        . $SolutionPath
    }

    It 'ValueLine is the line that reads registry values' {
        $ValueLine | Should -Be 2 -Because 'values are properties of a key and are read with Get-ItemProperty, Get-ChildItem only lists subkeys'
    }

    It 'CertificateLine is the line that returns certificates' {
        $CertificateLine | Should -Be 3 -Because 'certificates live on the drive Cert:'
    }

    It 'UserLine is the line that reads settings of the current user' {
        $UserLine | Should -Be 4 -Because 'HKCU: is the hive of the signed-in user, HKLM: belongs to the machine'
    }

    It 'ExpiryProperty is the property with the expiry date' {
        ([string]$ExpiryProperty).Trim() | Should -Be 'NotAfter' -Because 'a certificate is valid from NotBefore until NotAfter'
    }
}
