# Task

The line in your exercise file decides whether a service state needs attention. It compares
`$Status` four times. Rewrite it.

1. Define the list `$ProblemStates` with the four states from the chain.
2. Assign `$NeedsAttention` with a single comparison that uses `-in`. No `-or` remains.

Leave the line with `param` as it is. `$NeedsAttention` must be the same as now for every
state.
