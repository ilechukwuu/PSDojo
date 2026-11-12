param($SolutionPath)

Describe 'Ask the load balancer until APP-01 answers' {
    BeforeAll {
        . $SolutionPath -Responses @('Timeout', 'Timeout', 'OK', 'OK') -MaxAttempts 4
        $attemptsThird = $Attempt
        $succeededThird = $Succeeded

        . $SolutionPath -Responses @('OK', 'Timeout', 'Timeout', 'Timeout') -MaxAttempts 4
        $attemptsFirst = $Attempt
        $succeededFirst = $Succeeded

        . $SolutionPath -Responses @('Timeout', 'Timeout', 'Timeout', 'Timeout', 'OK') -MaxAttempts 4
        $attemptsNever = $Attempt
        $succeededNever = $Succeeded
    }

    It 'The loop stops at the first OK' {
        $attemptsThird | Should -Be 3 -Because 'the loop must end as soon as the status is OK, not only when the attempts are used up'
        $succeededThird | Should -BeTrue
    }

    It 'One attempt is enough when the first answer is OK' {
        $attemptsFirst | Should -Be 1 -Because 'a do loop runs once and then checks the condition'
        $succeededFirst | Should -BeTrue
    }

    It 'The loop gives up after the maximum number of attempts' {
        $attemptsNever | Should -Be 4 -Because 'the second way out is $Attempt -ge $MaxAttempts'
        $succeededNever | Should -BeFalse -Because 'after four timeouts the last status is not OK'
    }
}
