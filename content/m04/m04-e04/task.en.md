# Task

A colleague started an inventory script for the report share on FS-02. Three of its lines
contain a mistake. Fix them and change nothing else. Leave the line with `param` as it is,
the dojo uses it to pass a test folder.

When the script works:

- `$AliasTarget` holds the text Get-ChildItem.
- `$HasReports` is `$true` when a folder named reports exists below `$Root`.
- A folder named archive exists below `$Root`, and `$Archive` holds it.
