#!/bin/bash
dir=$1
for f in 0.1 0.5; do
    for q in Q1 Q2 Q3 Q6 Q9 Q11; do
        for e in cqels csparql "querystreamer_type=graphs;interval=false;caching=false"; do
            files=""
            for d in 1 5 10 20 50; do
                files="$files $dir/$e/r=1.0;f=$f;dup=$d;q=[$q.txt].csv"
            done
            outfile="$dir/$e/r=1.0;f=$f;dup=averaged;q=[$q.txt].csv"
            ./assemble_averaged_csv.sh $files > $outfile
        done
    done
done
