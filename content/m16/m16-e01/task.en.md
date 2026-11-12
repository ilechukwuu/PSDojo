# Task

The patch plan lists the file servers in the order in which they are patched. You need a
few facts from that list.

1. Store the five server names `FS-01`, `FS-02`, `FS-03`, `FS-04` and `FS-05` as an array
   in `$Servers`, in this order.
2. Store the first server in `$Pilot`. It is patched first.
3. Store the last server in `$Final`. Use a negative index.
4. Store the second and third server as an array in `$WaveTwo`. Use a range.
5. Store the number of servers in `$Total`.
