param($SolutionPath)

Describe 'The retry counter that stays at zero' {
    BeforeAll {
        . $SolutionPath
    }

    It 'Result1: the second call starts from zero again' {
        $Result1 | Should -Be 1 -Because 'the variable written inside the function is gone after each call, so every call reads the outer 0 and returns 1'
    }

    It 'Result2: the outer variable is unchanged' {
        $Result2 | Should -Be 0 -Because 'an assignment inside a function creates a new variable in the function and leaves the outer one alone'
    }

    It 'Result3: the script prefix reaches the outer variable' {
        $Result3 | Should -Be 1 -Because '$script:Retries is the variable of the script file, and it was 0 before this one call'
    }

    It 'Result4: reading looks outward' {
        ([string]$Result4).Trim() | Should -Be 'Site Kiel' -Because 'the function has no $Site of its own, so PowerShell finds the one of the script'
    }

    It 'Result5: an if block is not a scope' {
        ([string]$Result5).Trim() | Should -Be 'retried' -Because 'a variable set inside an if block belongs to the scope around it'
    }
}
