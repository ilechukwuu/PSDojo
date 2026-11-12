# Task

A process hangs on terminal server TS-03 and a user cannot log off. You do not know yet which
cmdlets deal with processes, so you search before you act.

1. Store every command with the noun `Process` in `$ProcessCommands`.
2. Store every command with the verb `Stop` in `$StopCommands`.
3. After the incident the temporary profile has to be cleaned up. Store every command whose
   name ends with `-Item` in `$ItemCommands`.

Use `Get-Command` in all three lines.
