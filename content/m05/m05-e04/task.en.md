# Task

For the capacity report of TS-03 you need the complete process list and the single largest
process, taken at the same moment. `Get-Process` may be called only once.

1. Write one pipeline that starts with `Get-Process`, stores all processes in the variable
   `AllProcesses` with `Tee-Object`, sorts by `WorkingSet64` descending and keeps the first
   one. Store the result of the pipeline in `$Largest`.
2. Start a second pipeline from `$AllProcesses`, without calling `Get-Process` again, and
   store the number of processes in `$Total`.
