# Task

The service desk tool shows a recommended action and a server role for every alert. Your
script receives `$Status` and `$Server`.

1. Set `$Action` with a `switch` on `$Status`:
   - `Running` gives `Nothing to do`
   - `Stopped` gives `Start the service`
   - `Paused` gives `Resume the service`
   - everything else gives `Check by hand`
2. Set `$Role` with a `switch -Wildcard` on `$Server`:
   - names starting with `FS-` give `File server`
   - names starting with `PRN-` give `Print server`
   - names starting with `APP-` give `Application server`
   - everything else gives `Unknown`

Leave the line with `param` as it is.
