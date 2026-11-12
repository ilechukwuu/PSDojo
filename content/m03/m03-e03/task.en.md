# Task

A report from file server FS-02 arrives with broken umlauts. You suspect the encoding and
want to know which cmdlets let you control it. While you are at it you document where the
file cmdlets come from.

1. Store every cmdlet that has a parameter named `Encoding` in `$EncodingCommands`. Limit
   the result to cmdlets.
2. Store every command of the module `Microsoft.PowerShell.Management` in
   `$ManagementCommands`.
3. Store the names of all parameters of `Get-Content` in `$ContentParameters`.
4. Store the name of the module that `Get-Content` comes from in `$ContentModule`.
