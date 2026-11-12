# Task

HR sends a list in which every entry looks different. Before the accounts are created you
clean the values up. The first lines of your exercise file hold three raw values. Leave
them as they are.

1. Replace every run of white space in `$RawName` with a single space and store the result
   in `$Name`.
2. `$Name` now has the form `Last, First`. Turn it into `First Last` with one `-replace`
   and two groups, and store the result in `$DisplayName`.
3. Remove everything from the `@` on from `$Mail` and store the rest in `$Login`.
4. Match `$Ticket` with a pattern that has the named groups `Prefix` and `Number`: letters,
   a hyphen, digits. Store the two parts in `$TicketPrefix` and, as a whole number, in
   `$TicketNumber`.
