# Task

The finance department sends a usage report to FS-02 every month. Your script has to record
a few facts about the newest file. The dojo passes the path of the file as `$ReportFile`,
and the first line stores the file object in `$File` for you.

1. Store the size of the file in bytes in `$Size`.
2. Store the file extension in `$Extension`.
3. Store the year in which the file was last written in `$Year`.
4. Store the name of the folder the file lies in, without the path, in `$FolderName`.

Read everything from `$File`. Leave the first two lines as they are.
