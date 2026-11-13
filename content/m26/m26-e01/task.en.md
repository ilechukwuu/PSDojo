# Task

The helpdesk gets a function that describes which share of which file server is to be
measured. It must refuse to run without a server name, and it must be quiet unless asked.

Define a function `Get-ShareUsage`:

1. It carries `[CmdletBinding()]`.
2. It has a mandatory parameter `$ComputerName` (text) and a parameter `$Share` (text) with
   the default `Data`.
3. It writes the message `Reading share <Share> on <ComputerName>` with `Write-Verbose`,
   with the two values filled in.
4. It returns one object with the properties `ComputerName` and `Share`.
