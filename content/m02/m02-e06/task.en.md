# Task

The service desk receives a ticket: a script works for one colleague and fails for another.
Before anyone looks at the code, the ticket needs the facts about where it ran. Write the
three lines that collect them.

1. Store the name of the host in `$HostName`.
2. Store the first number of the PowerShell version in `$Major`.
3. Store the edition in `$Edition`.

Read the values from `$Host` and `$PSVersionTable`. Do not type the results as text: the
dojo runs your file in its own host, where the values differ from the ones in your editor.
