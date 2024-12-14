#!/bin/bash

# executa clips cu codul si scrie timpii intr-un output.txt intermediar
echo "(batch go)
(exit)" | ./fz_clips go | grep Decision

#!/bin/bash

# Verifică dacă fișierul times.csv există deja
if [ ! -f times.csv ]; then
    # Dacă fișierul nu există, crează fișierul cu un antet
    echo -n "Decision Time" > times.csv
else
    # Dacă fișierul există deja, adaugă un separator de coloană (virgulă)
    echo -n "," >> times.csv
fi

# Citește fișierul output.txt, caută liniile care conțin "Decision time" și extrage timpii
grep "Decision time" output.txt | sed 's/.*Decision time: \([0-9e.-]*\) sec.*/\1/' | tr '\n' ',' >> times.csv

# Adaugă o nouă linie la sfârșit pentru a separa valorile de pe rânduri
echo "" >> times.csv

echo "Timpii au fost salvați într-o coloană nouă în times.csv"

