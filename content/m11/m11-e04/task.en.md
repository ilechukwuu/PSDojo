# Task

The check script in your exercise file is used by a monitoring job that captures its result.
The job receives rubbish. Three lines send something to the wrong stream. Fix them.

When the script works:

- Its result consists of the three Nordwind service names and nothing else.
- The text `Reading services from APP-01` is a verbose message.
- The warning `Nordwind check finished with warnings` is written to the file `warnings.log`
  in `$LogFolder`.

Leave the line with `param` as it is.
