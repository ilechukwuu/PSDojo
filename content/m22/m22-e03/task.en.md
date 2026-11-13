# Task

A backup script on FS-01 builds its target names from the source paths. Before you change
it you want to be sure what each expression returns. The file
`D:\Backup\sql\nordwind-2026.tar.gz` exists. `$File` is the result of `Get-Item` for it.

Predict the results. Do not run anything.

1. `Split-Path -Path 'D:\Backup\sql\nordwind-2026.tar.gz' -Leaf` Store the text in
   `$Result1`.
2. `Split-Path -Path 'D:\Backup\sql\nordwind-2026.tar.gz' -Parent` Store it in `$Result2`.
3. `$File.BaseName` Store it in `$Result3`.
4. `$File.Extension` Store it in `$Result4`.
5. `Test-Path -Path 'D:\Backup\sql\nordwind-2026.tar.gz' -PathType Container` Store `$true`
   or `$false` in `$Result5`.
6. `Join-Path -Path 'D:\Backup\' -ChildPath '\sql'` Store the text in `$Result6`.
