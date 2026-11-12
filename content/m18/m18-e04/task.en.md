# Task

The maintenance script in your exercise file rates a server before patching. It has three
logic mistakes. Fix them. Leave the line with `param` as it is.

When the script works:

- `$ShouldStart` is `$true` only when `$Status` is `Stopped`, and `$Status` keeps its
  value.
- `$Priority` is `High` below 10 percent free, `Medium` below 20 and `Low` otherwise.
- `$Role` is exactly one text: `File server` for names that start with `FS-`, otherwise
  `Other`.
