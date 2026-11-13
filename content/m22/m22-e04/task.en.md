# Task

Before every update of the Nordwind application a script backs up the configuration and
moves the log files out of the way. After the last update the backup folder was empty and
the logs were still in place. The script in your exercise file has three mistakes. Fix
them. Leave the line with `param` as it is.

When the script works:

- The folder `backup` below `$Root` contains everything from `config`, including the
  subfolder.
- The folder `archive` below `$Root` exists and contains every `.log` file from `logs`.
- Other files in `logs` stay where they are.
