# How objects flow

A pipeline does not wait until the first command has finished. As soon as the first command
produces one object, that object moves on to the second command, then to the third. This is
called streaming. It keeps memory use low and lets `Select-Object -First 1` stop the whole
pipeline early.

Some commands cannot stream. `Sort-Object` has to see every object before it can release
the first one, so it collects everything and only then passes it on.

For your result this means: each command sees only what the command before it let through.

- Sort, then take the first two: the two largest of everything.
- Take the first two, then sort: only the first two that happened to arrive, sorted.

When a pipeline surprises you, cut it off after the first command, look at the result, then
add the next command.

## Example

```powershell
Get-ChildItem -Path D:\Logs | Sort-Object -Property Length -Descending | Select-Object -First 1
Get-ChildItem -Path D:\Logs | Select-Object -First 1 | Sort-Object -Property Length -Descending
```

Line 1 returns the largest file. Line 2 returns whichever file came first.
