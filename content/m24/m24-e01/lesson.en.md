# Script blocks

You have written script blocks since the pipeline modules: the braces after `Where-Object`
are one. A script block is a piece of code as a value. It can be stored in a variable,
passed to a command and run later, as often as needed.

**Defining does not run it.** `$Block = { Get-Date }` stores the code. Nothing happens
yet.

**The call operator runs it.** `& $Block` executes the code and returns its output.

**`param` gives it input.** A script block can start with a `param` block just like a
script. The caller passes the values after the block, by position or by name.

Everything a script block outputs is its result, exactly as with a script.

This turns a calculation you need in several places into one definition. If the rule
changes, you change one line.

## Example

```powershell
$ToPercent = {
    param($Part, $Total)
    [math]::Round($Part / $Total * 100, 1)
}

& $ToPercent 18 240
& $ToPercent -Part 51 -Total 60
```

The results are 7.5 and 85.
