# Task

The script in your exercise file adds up the free disk space of four file servers and
remembers a server that is running low. You do not need to understand the loop yet. Let the
debugger show you what happens.

Set a breakpoint on the line `$Total = $Total + $FreeGB[$i]` and start with F5. Each time
the script stops, press F10 once and then read `$Total` in the console.

1. Which value does `$Total` have after the line has run for the second time? Store it in
   `$TotalAfterSecondPass`.
2. Which server name ends up in `$Low`? Store it as text in `$LowServer`.
3. Which value does `$Total` have when the script has finished? Store it in `$FinalTotal`.
