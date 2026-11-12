# Layout

PowerShell does not care how a script looks. People do. A script that is laid out the same
way everywhere can be checked at a glance, and mistakes stand out.

The rules most teams agree on:

- One statement per line. A semicolon can join several statements on one line, but then the
  second one is easy to miss.
- A space on each side of `=` and of other operators.
- No tabs. Indent with four spaces, and only where a block is nested. Lines at the top
  level start in the first column.

VS Code formats a file for you: Shift+Alt+F, or right-click and choose Format Document. The
ISE has no formatter, there you do it by hand. Turn on visible white space while you learn:
View, Render Whitespace in VS Code, and the option Show Whitespace in the ISE settings.

## Example

```powershell
$Server='FS-02';$Share='Transfer'

$Server = 'FS-02'
$Share = 'Transfer'
```

Line 1 and lines 3 to 4 do the same. In the first version the second assignment hides behind
the semicolon.
