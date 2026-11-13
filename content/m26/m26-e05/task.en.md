# Task

The function in your exercise file describes what is to happen with accounts that have not
logged on for a long time. It checks its input with three hand-written `if` statements.
Rewrite it.

1. Add `[CmdletBinding()]`.
2. `$Name` becomes mandatory.
3. `$Days` only accepts 30 to 365, declared with an attribute.
4. `$Mode` only accepts `Report` and `Disable`, declared with an attribute.
5. No `if` and no `throw` may remain. The function still returns the same object.
