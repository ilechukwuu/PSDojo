# Task

You build the rows of the weekly disk report by hand, as objects, so that they can be
filtered and exported later.

1. Store an object with the properties `Server`, `Drive` and `FreeGB`, in this order, in
   `$Row1`. The values are `FS-01`, `D:` and 120.
2. Store a second object with the same properties in `$Row2`. The values are `FS-02`, `D:`
   and 8.
3. Store both objects as an array in `$Report`.
4. Store the rows of `$Report` whose `FreeGB` is below 20 in `$Low`.
5. Store the server names of all rows as plain text in `$Servers`.
