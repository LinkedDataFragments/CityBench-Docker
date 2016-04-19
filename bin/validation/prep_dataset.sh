#!/bin/bash
queries=(Q1 Q2 Q3 Q6 Q9 Q11)
duplicates=(1 16 32 64)
engines=(cqels csparql querystreamer)

dir=$1
colname=$2
colid=$3

for q in ${queries[@]}; do
    file="$dir/dataset-$colname-$q.csv"
    echo "duplicates,engine,value" > $file
    row=0
    for duplicate in ${duplicates[@]}; do
        let row++
        for engine in ${engines[@]}; do
            in="$dir/$engine/r=1.0;f=0.1;dup=$duplicate;q=[$q.txt].csv"
            #c=$(tail -n +2 $in | cut -d',' -f$colid | head -$row | tail -1)
            #line="$line,$c"
            #echo "$duplicate,$engine,$c" >> $file
            tail -n +2 $in | cut -d',' -f$colid | while read -r c; do
                echo "$duplicate,$engine,$c" >> $file
            done
        done
    done
done
