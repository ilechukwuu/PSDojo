# Shorter conditions

A condition that compares one value against several possibilities grows with every new
possibility:

`$Status -eq 'Stopped' -or $Status -eq 'Paused' -or $Status -eq 'StartPending'`

Each addition is a chance to mistype the variable or to pick the wrong operator, and the
line soon runs off the screen.

`-in` says the same in a few words. The value stands on the left, the list of allowed
values on the right. The result is true when the value is one of them. `-notin` is the
opposite.

Put the list in a variable with a telling name and you gain twice: the condition reads like
a sentence, and adding a value means adding one word to the list at the top.

`-contains` does the same with the sides swapped, list on the left.

## Example

```powershell
$ProblemStates = 'Stopped', 'Paused', 'StartPending'

$NeedsAttention = $Status -in $ProblemStates
$IsFine = $Status -notin $ProblemStates
```

Line 3 replaces a chain of three comparisons.
