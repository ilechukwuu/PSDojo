# Aufgabe

Du baust die Zeilen des wöchentlichen Datenträgerberichts von Hand, als Objekte, damit sie
sich später filtern und exportieren lassen.

1. Speichere ein Objekt mit den Eigenschaften `Server`, `Drive` und `FreeGB`, in dieser
   Reihenfolge, in `$Row1`. Die Werte sind `FS-01`, `D:` und 120.
2. Speichere ein zweites Objekt mit denselben Eigenschaften in `$Row2`. Die Werte sind
   `FS-02`, `D:` und 8.
3. Speichere beide Objekte als Array in `$Report`.
4. Speichere die Zeilen von `$Report`, deren `FreeGB` unter 20 liegt, in `$Low`.
5. Speichere die Servernamen aller Zeilen als reinen Text in `$Servers`.
