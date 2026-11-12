# Task

A trainee wrote a small check for TS-03 and both of its pipelines fail to bind. Fix them.

- `$Running` must hold the two processes named in `$Rows`. Fix it by renaming the property
  in the two rows so that it binds. Do not change the line `$Running = ...`.
- `$Stamp` must hold today's date as text in the format `yyyyMMdd`. Here the value does not
  belong in the pipe.
