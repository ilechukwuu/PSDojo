param($SolutionPath)

Describe 'Input check before a server is added' {
    BeforeAll {
        . $SolutionPath
        $goodName = $IsServerName
        $goodFqdn = $IsInternal
        $goodOwner = $Owner

        . $SolutionPath -Candidate 'XFS-021' -Fqdn 'fs-02.nordwindXexample' -Person 'Yilmaz, Murat'
        $badName = $IsServerName
        $badFqdn = $IsInternal
        $otherOwner = $Owner

        . $SolutionPath -Candidate 'FS-02' -Fqdn 'fs-02.nordwind.example.evil.test' -Person 'Keller, Anna'
        $longFqdn = $IsInternal
    }

    It 'A correct server name is accepted' {
        $goodName | Should -BeTrue -Because 'FS-02 is FS- followed by two digits'
    }

    It 'A text that only contains a server name is rejected' {
        $badName | Should -BeFalse -Because 'without ^ and $ the pattern matches anywhere inside XFS-021'
    }

    It 'An internal name is accepted' {
        $goodFqdn | Should -BeTrue -Because 'the name ends with .nordwind.example'
    }

    It 'A name with other characters instead of the dots is rejected' {
        $badFqdn | Should -BeFalse -Because 'an unescaped dot matches any character. A real dot is written \.'
    }

    It 'A name that only contains the domain in the middle is rejected' {
        $longFqdn | Should -BeFalse -Because 'ends with means an anchor $ at the end of the pattern'
    }

    It 'Owner is first name and last name' {
        $goodOwner | Should -BeExactly 'Anna Keller' -Because 'the replacement with $2 and $1 must be in single quotes'
        $otherOwner | Should -BeExactly 'Murat Yilmaz'
    }
}
