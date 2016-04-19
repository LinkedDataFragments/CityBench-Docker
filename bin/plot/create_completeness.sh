#!/bin/bash
dir=$1
for f in 0.1 0.5; do
    for d in 1 16 32 64; do
        outfile="$dir/completeness-$f-$d.csv"
        echo 'q,querystreamer,csparql,cqels' > $outfile
        for q in Q1 Q2 Q3 Q6 Q9 Q11; do
            line="$q"
            for e in "querystreamer_type=graphs;interval=false;caching=false" csparql cqels; do
                file="$dir/$e/r=1.0;f=$f;dup=$d;q=[$q.txt].csv"
                e=$(tail -1 $dir/$e/r\=1.0\;f\=$f\;dup\=$d\;q\=\[$q.txt\].csv | awk -F',' '{print $8}')
                if [ "$e" == "null" ] || [ "$e" == "" ]; then
                    e="0"
                fi
                line="$line,$e"
            done
            echo $line >> $outfile
        done
    done
done
