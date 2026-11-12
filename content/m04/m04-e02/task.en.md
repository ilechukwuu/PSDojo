# Task

A deployment tool tells every script at which site it runs through the environment variable
`DOJO_SITE`. For practice the first line of your exercise file sets it. Leave that line as
it is and work with the `Env:` drive below it.

1. Store all environment variables in `$AllVariables`.
2. Store the value of `DOJO_SITE` in `$Site`. Only the value, not the whole item.
3. Create the environment variable `DOJO_TICKET` with the value `INC-4711` using `New-Item`.
4. Store in `$TicketExists` whether `DOJO_TICKET` exists. Use `Test-Path`.
