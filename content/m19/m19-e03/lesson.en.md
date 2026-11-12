# for, while and do

Three more loops for cases where there is no list to walk through.

**for** counts. Its header has three parts separated by semicolons: a start, a condition
and a step. `for ($i = 0; $i -lt 3; $i++)` runs with `$i` 0, 1 and 2.

**while** repeats as long as a condition is true. The condition is checked before each
pass, so the block may never run.

**do** checks at the end, so the block runs at least once. `do { } while (...)` repeats
while the condition is true, `do { } until (...)` repeats until it becomes true.

Two keywords change the flow inside any loop:

- `break` leaves the loop at once.
- `continue` skips the rest of this pass and goes on with the next one.

## Example

```powershell
for ($i = 0; $i -lt 3; $i++) { "Pass $i" }

$Free = 30
while ($Free -lt 20) { 'never runs' }

do { 'runs once' } while ($Free -lt 20)
```

The `for` runs three times. The `while` block never runs. The `do` block runs once although
its condition is false.
