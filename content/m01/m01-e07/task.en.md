# Task

An administrator has left the company. His handover note for file server FS-02 is full of
shorthand such as `gci`, `gcm`, `gal` and `gps`. You write the documentation that the note
should have been.

1. Resolve the four aliases `gci`, `gcm`, `gal` and `gps` with a single call and store the
   result in `$Translation`.
2. Store every alias that points to `Get-ChildItem` in `$ItemAliases`.
3. For your own console session create the alias `procs` for `Get-Process`.
4. Call your new alias and store its output in `$FromAlias`.
