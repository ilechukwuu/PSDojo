# The debugger

Reading a script tells you what it should do. The debugger shows you what it really does.
It stops the script at a line you choose and lets you look around while everything is still
in memory. The keys are the same in ISE and VS Code. Save the file first, the debugger only
works on saved files.

- **F9** sets or removes a breakpoint on the current line. A red mark appears.
- **F5** starts the script. It stops at the first breakpoint and highlights the line that
  runs next.
- **F10** runs that one line and stops again. **F11** does the same but also steps into
  functions.
- **F5** continues to the next breakpoint, **Shift+F5** ends debugging.

While the script is stopped, the console prompt starts with `[DBG]`. Type a variable name
there to see its value. You can also hover over a variable in the script pane.

## Example

```powershell
$Total = 0
$Total = $Total + 120
$Total = $Total + 35
```

Set a breakpoint on line 3 and press F5. The script stops before line 3 runs. Typing
`$Total` in the console shows 120.
