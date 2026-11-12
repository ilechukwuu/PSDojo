# Task

The service desk wants the state of the Nordwind services on APP-01 attached to a ticket as
a text file and pasted into the ticket text. The dojo passes the target folder as
`$ReportFolder`.

1. Write a table of the services whose name starts with `Nordwind`, with the columns `Name`,
   `Status` and `StartType`, to the file `nordwind.txt` in `$ReportFolder`. Use
   `-Encoding utf8` and `-Width 200`.
2. Store the same table as text in `$TicketText`, also with `-Width 200`.

Leave the line with `param` as it is.
