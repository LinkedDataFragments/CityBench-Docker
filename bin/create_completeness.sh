#!/bin/bash
dir=$1
for f in 0.1 0.5; do
    for d in 1 5 10 20 50; do
        outfile="$dir/completeness-$f-$d.csv"
        echo 'q,querystreamer,csparql,cqels' > $outfile
        for q in Q1 Q2 Q3 Q6 Q9; do
            line="$q"
            for e in cqels csparql "querystreamer_type=graphs;interval=false;caching=false"; do
                file="$dir/$e/r=1.0;f=$f;dup=$d;q=[$q.txt].csv"
                e=$(tail -1 output_small/cqels/r\=1.0\;f\=0.1\;dup\=1\;q\=\[Q1.txt\].csv | awk -F',' '{print $7}')
                line="$line,$e"
            done
            echo $line >> $outfile
        done
    done
done
