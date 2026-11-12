# Task

The two lines in your exercise file belong to a check that runs every minute against
APP-01. Each of them fetches all services and then throws most of them away.

Rewrite them so that `Get-Service` filters by name itself:

1. `$NordwindDown`: the name filter moves into the parameter `-Name`. The status stays in
   `Where-Object`.
2. `$Sql`: both names go to `-Name` as a list. No `Where-Object` is needed any more.

Both variables must hold the same services as now.
