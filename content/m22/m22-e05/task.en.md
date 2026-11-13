# Task

The terminal server TS-03 collects temporary files of an import tool. You write the cleanup
that runs every night, and it must offer a dry run. The dojo passes the folder as `$Root`
and calls your script once with `-WhatIf` and once without.

1. Store every file with the extension `.tmp` below `$Root`, in all subfolders, that was
   last written more than 7 days ago in `$Candidates`.
2. Delete each file in `$Candidates` with `Remove-Item`. Hand the switch of the script on,
   so that with `-WhatIf` nothing is deleted.

Newer `.tmp` files and all other files must stay. Leave the line with `param` as it is.
