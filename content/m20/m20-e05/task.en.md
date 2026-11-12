# Task

The script in your exercise file checks input before a server is added to the monitoring.
Three patterns are wrong. Fix them. Leave the line with `param` as it is.

When the script works:

- `$IsServerName` is true only when `$Candidate` is exactly `FS-` followed by two digits.
- `$IsInternal` is true only when `$Fqdn` ends with `.nordwind.example`, with real dots.
- `$Owner` turns `$Person` from the form `Last, First` into `First Last`.
