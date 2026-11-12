# Task

The disk monitoring passes the free space of a volume in percent as `$FreePercent`. Your
script rates it.

Set `$State` to one of three texts:

- `Critical` when `$FreePercent` is below 10.
- `Warning` when it is below 20 but not below 10.
- `OK` in every other case.

Then set `$NeedsTicket` to `$true` when the state is not `OK`, otherwise to `$false`.

Leave the line with `param` as it is. The dojo passes different values through it.
