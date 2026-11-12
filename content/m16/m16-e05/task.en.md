# Task

The script in your exercise file writes the announcement for a patch night. It works for
exactly three servers, because it names every position. Rewrite it so that it works for any
number.

1. `$Line` joins all servers with a comma and a space. Use `-join`.
2. `$LastTwo` holds the last two servers. Use a slice with negative positions.
3. `$Summary` stays a text of the form `3 servers: FS-01, FS-02, FS-03`, built from the
   count and `$Line`.

No `+` may remain. Leave the line with `param` as it is, the dojo passes different lists
through it.
