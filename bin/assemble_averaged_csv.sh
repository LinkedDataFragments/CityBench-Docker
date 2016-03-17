#!/bin/bash
echo 'duplicates,id,latency,server-memory,client-memory,server-cpu,client-cpu'
for file in "$@"; do
    echo -n $(echo "$file" | sed "s/^.*dup=\([0-9]*\).*$/\1/")
    tail -n +2 $file | gawk -F',' 'BEGIN{\
            for(i=1; i<=NF; i++){sum[i]=0.0}\
        }\
        {\
            for(i=1; i<=NF; i++){sum[i]+=$i}\
        }\
        END {\
            for(i=1; i<=NF; i++){printf ",%.4f",sum[i]/NR} printf "\n"\
        }'
done

