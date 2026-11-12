# Task

The patch window for the file servers is planned for 14 March 2026 at 22:00. The change
ticket needs a few values from you.

1. Store the start of the patch window as a date object in `$PatchStart`: 14 March 2026,
   22:00:00. Use `Get-Date` with the parameters `-Year`, `-Month`, `-Day`, `-Hour`, `-Minute`
   and `-Second`.
2. The report file gets today's date in its name. Store today's date as text in the format
   `yyyyMMdd` in `$TicketStamp`.
3. Two processes must be running before patching starts. Store the processes `spoolsv` and
   `lsass` in `$Watched` with a single call of `Get-Process`.
4. Store the syntax of `Stop-Process` in `$Syntax`. Use `Get-Command` with the switch
   `-Syntax`.

Write every parameter name out.
