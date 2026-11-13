# Scope

Every script and every function gets its own **scope**, a private set of variables. The
rules are short:

- **Reading looks outward.** If a function reads a variable it has not set itself,
  PowerShell looks in the scope that called it, then further out.
- **Writing stays inside.** An assignment in a function creates a new variable in the
  function's scope. The outer variable of the same name keeps its value. When the function
  ends, its variables are gone.
- **Blocks are not scopes.** `if`, `foreach`, `while` and `switch` belong to the scope
  around them. A variable set inside an `if` is still there afterwards.

A prefix reaches a specific scope: `$script:Count` is the variable at the level of the
script file, `$global:Count` the one of the whole session.

Reading from outside is convenient and makes functions hard to test. Later modules pass
everything in through parameters instead.

## Example

```powershell
$Count = 5

function Add-Attempt {
    $Count = $Count + 1
    $Count
}

Add-Attempt
$Count
```

The function reads 5 from outside, writes 6 into its own `$Count` and outputs 6. Line 9
outputs 5.
