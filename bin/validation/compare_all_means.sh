#!/bin/bash
queries=(Q1 Q2 Q3 Q6 Q9 Q11)
types=(completeness latency server-cpu)

dir="output"
for type in ${types[@]}; do
    out="$dir/validation-$type.csv"
    echo "query,eqcqels,peqcqels,diffcqels,goodcqels,eqcsparql,peqcsparql,diffcsparql,goodcsparql" > $out
    factor=1
    if [ "$type" = "completeness" ]; then factor=-1; fi
    for query in ${queries[@]}; do
        file="$dir/dataset-$type-$query.csv"
        line=$(Rscript compare_means.R --args $file $factor)
        line="$query,$line"
        echo $line >> $out
    done
done

