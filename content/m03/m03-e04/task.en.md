# Task

A trainee wrote three lines for the handover documentation of file server FS-02 and guessed
a parameter name in each of them. Every line fails.

Find the real parameter names with `Get-Command -Syntax` or `Get-Help -Parameter *` and fix
the three lines. Change only the wrong parameter names.

When the script works:

- `$DirAliases` holds the aliases of `Get-ChildItem`.
- `$FirstThree` holds the first three commands with the verb Get.
- `$PatchDate` holds the text 14.03.2026.
