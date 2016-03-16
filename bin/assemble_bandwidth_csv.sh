#!/bin/bash

i=0
for file in "$@"; do
    cat $file | ./transformproxybins.js | sed "s/bytes/$file/" > .tmp_$i.csv
    let i++
done

paste -d, .tmp_*.csv | awk '{printf("%s,%s\n", (NR-1)*1, $0)}' | sed "s/,,/,0,/g"

rm .tmp_*.csv

