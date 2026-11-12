# Task

An inventory export for the file servers arrives as text. The first lines of your exercise
file hold three pieces of it. Leave them as they are.

1. Split `$ServerText` at the semicolons and store the list in `$Servers`.
2. Join `$Servers` with a comma and a space between the names and store the text in
   `$ServerLine`.
3. Store the numbers 1 to 4 in `$DriveNumbers`. Use the range operator.
4. Store in `$IsNumber` whether `$SizeText` is of the type `int`. Use `-is`.
5. Convert `$SizeText` to `int` with `-as` and store the result in `$Size`.
6. Convert `$BrokenText` to `int` with `-as` and store the result in `$Broken`.
