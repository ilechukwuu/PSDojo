# Aufgabe

Der Kapazitätsbericht für APP-01 muss für Menschen lesbar sein, die nicht in Bytes denken.

Speichere ein Objekt pro Prozess in `$Report`. Jedes Objekt hat genau diese drei
Eigenschaften, in dieser Reihenfolge:

1. `Name`, unverändert.
2. `MemoryMB`: `WorkingSet64` geteilt durch `1MB`, gerundet auf eine ganze Zahl.
3. `Team`: der Wert der Eigenschaft `Category` unter dem neuen Namen.

Speichere danach dieselben Objekte, sortiert nach `MemoryMB`, die größten zuerst, in
`$Sorted`.
