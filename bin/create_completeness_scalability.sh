#!/bin/bash
dir=$1
for q in Q1 Q2 Q3 Q6 Q9 Q11; do
    for f in 0.1 0.5; do
        outfile="$dir/completeness-$f-$q.csv"
        echo 'duplicates,querystreamer,csparql,cqels' > $outfile
        for d in 1 16 32 64; do
            line=$d
            for e in "querystreamer_type=graphs;interval=false;caching=false" csparql cqels ; do
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
