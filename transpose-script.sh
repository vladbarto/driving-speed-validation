#!/bin/bash

awk '
NR == 1 {next}  # Sari prima linie (antetul)
{
    for (i = 1; i <= NF; i++) {
        arr[i] = (arr[i] ? arr[i] "," $i : $i)
    }
}
END {
    for (i = 1; i <= length(arr); i++) {
        print arr[i]
    }
}
' times.csv > transposed_times.csv
echo "times transponsed"