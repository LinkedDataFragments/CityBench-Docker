#!/bin/bash

i=0
for file in "$@"; do
    cat $file | ./transformproxybins.js | sed "s/bytes/$file/" > .tmp_$i.csv
    let i++
done

paste -d, .tmp_*.csv

rm .tmp_*.csv

