#!/bin/bash
echo 'duplicates,id,latency,count,server-memory,client-memory,server-cpu,client-cpu,completeness'
for file in "$@"; do
    if [ -f $file ] && [ $(wc -l <$file) -gt 0 ]; then
        echo -n $(echo "$file" | sed "s/^.*dup=\([0-9]*\).*$/\1/")
        tail -n +2 $file | gawk -F',' 'BEGIN{\
                for(i=1; i<=NF; i++){max[i]="NaN"}\
            }\
            {\
                for(i=1; i<=NF; i++){if($i>max[i]&&$i!="NaN")max[i]=$i}\
            }\
            END {\
                for(i=1; i<=NF; i++){printf ",%s",max[i]} printf "\n"\
            }'
    fi
done

