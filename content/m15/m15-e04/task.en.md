# Task

The certificate check for WEB-01 never warns. It has three date mistakes. Fix them without
changing the first two lines.

When the script works:

- `$Expires` is the date 3 April 2026.
- `$WarnFrom` is 30 days before `$Expires`.
- `$ShouldWarn` is `$true`, because today lies on or after `$WarnFrom`.
