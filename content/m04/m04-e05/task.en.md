# Task

The script in your exercise file collects information about the report share. It works, but
it changes the location twice and uses relative paths. Rewrite it so that it never changes
the location.

1. Remove every `Set-Location` and every `cd`.
2. Give each remaining command a full path that starts with `$Root`.

`$Reports`, `$HasArchive` and `$Readme` must hold exactly what they hold now. Leave the line
with `param` as it is.
