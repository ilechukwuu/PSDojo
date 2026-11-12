# Task

Extend the check for APP-01 so that it reports problems properly.

1. Write the verbose message `Reading services from APP-01`.
2. Store the services that are `Stopped` and have the `StartType` `Automatic` in `$Broken`.
3. Store the number of these services in `$Count`. `@($Broken).Count` gives it.
4. Write a warning with the text `Stopped automatic services: ` followed by the number,
   for example `Stopped automatic services: 3`.
5. Return the names of the services in `$Broken` as the result of the script.
