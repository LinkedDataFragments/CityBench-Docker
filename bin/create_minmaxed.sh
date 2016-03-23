#!/bin/zsh

re='^[0-9]+'

dir=$1
for f in 0.1 0.5; do
    for d in 1 20 50; do
        for e in cqels csparql "querystreamer_type=graphs;interval=false;caching=false"; do
            unset min
            unset max
            unset total
            unset count
            typeset -A min
            typeset -A max
            typeset -A total
            typeset -A count
            maxrow=0
            maxcol=0
            for q in Q1 Q2 Q3 Q6 Q9 Q11; do
                file="$dir/$e/r=1.0;f=$f;dup=$d;q=[$q.txt].csv"
                r=0
                for line in $(tail -n+2 $dir/$e/r\=1.0\;f\=$f\;dup\=$d\;q\=\[$q.txt\].csv); do
                    c=0
                    for v in $(echo $line | sed "s/,/ /g"); do
                        if [[ "$v" == "null" ]] || [[ "$v" == "" ]] || [[ "$v" == "NaN" ]]; then
                            v="0"
                        fi

                        prev_min=$min[$r'.'$c]
                        if ! [[ $prev_min =~ $re ]] || [[ "1" -eq "$(echo "$v < $prev_min" | bc -l)" ]]; then
                            min[$r'.'$c]=$v
                        fi

                        prev_max=$max[$r'.'$c]
                        if ! [[ $prev_max =~ $re ]] || [[ "1" -eq "$(echo "$v > $prev_max" | bc -l)" ]]; then
                            max[$r'.'$c]=$v
                        fi

                        prev_total=$total[$r'.'$c]
                        if ! [[ $prev_total =~ $re ]]; then
                            prev_total="0"
                        fi
                        total[$r'.'$c]=$(echo "scale=2;$prev_total + $v" | bc -l)

                        prev_count=$count[$r'.'$c]
                        if ! [[ $prev_count =~ $re ]]; then
                            prev_count="0"
                        fi
                        count[$r'.'$c]=$(echo "scale=2;$prev_count + 1" | bc -l)

                        if [ $c -gt $maxcol ]; then maxcol=$c; fi
                        let c++
                    done
                    if [ $r -gt $maxrow ]; then maxrow=$r; fi
                    let r++
                done
            done

            outfilemin="$dir/$e/r=1.0;f=$f;dup=$d;q=min.csv"
            outfilemax="$dir/$e/r=1.0;f=$f;dup=$d;q=max.csv"
            outfileavg="$dir/$e/r=1.0;f=$f;dup=$d;q=avg.csv"
            line="id,latency,count,server-memory,client-memory,server-cpu,client-cpu,compl"
            echo $line > $outfilemin
            echo $line > $outfilemax
            echo $line > $outfileavg
            if [ $maxrow -gt "0" ] && [ $maxcol -gt "0" ]; then
                for r in $(seq 1 1 $maxrow); do
                    linemin="$r"
                    linemax="$r"
                    lineavg="$r"
                    for c in $(seq 1 1 $maxcol); do
                        i=${min[${r}'.'${c}]}
                        a=${max[${r}'.'${c}]}
                        avg=$(echo "scale=2;${total[${r}'.'${c}]} / ${count[${r}'.'${c}]}" | bc -l)
                        linemin=$linemin","$i
                        linemax=$linemax","$a
                        lineavg=$lineavg","$avg
                    done
                    echo $linemin >> $outfilemin
                    echo $linemax >> $outfilemax
                    echo $lineavg >> $outfileavg
                done
            fi
        done
    done
done
