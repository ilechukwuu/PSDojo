# Task

After a restart your script asks the load balancer whether APP-01 answers again. For
practice the answers are prepared: `$Responses` is a list, and the answer to attempt number
1 is `$Responses[0]`, to attempt 2 `$Responses[1]` and so on.

Write a `do` loop with `until`:

1. In each pass read the answer for the current attempt into `$Status` and count the
   attempt in `$Attempt`. `$Attempt` starts at 0.
2. The loop ends when `$Status` is `OK` or when `$Attempt` has reached `$MaxAttempts`.
3. After the loop store in `$Succeeded` whether the last `$Status` was `OK`.

Leave the line with `param` as it is. The dojo passes different lists through it.
