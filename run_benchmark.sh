#!/bin/bash
duration="15m"
duration="1m" # For debugging
queries=(1 2 3 6 9 10 11)
engines=(querystreamer cqels csparql)
duplicates=(1 20 50)
frequencies=(0.1 0.5)

#annotations=(reification singletonproperties graphs implicitgraphs)
#intervals=(true false)
#cachings=(true false)
# We only test one (the best) combination, otherwise the nr of possibilities explodes.
annotations=(graphs)
intervals=(false)
cachings=(true)

nr=$(echo "${#queries[@]} * (${#engines[@]} - 1 + ${#annotations[@]} * ${#intervals[@]} * ${#cachings[@]}) * ${#duplicates[@]} * ${#frequencies[@]}" | bc -l)

function runjar {
    java -jar build/libs/CityBench-all-1.0.0.jar rate=1.0 frequency=$frequency duration=$duration queryDuplicates=$duplicate startDate=2014-08-11T11:00:00 endDate=2014-08-31T11:00:00 engine=$engine query=Q$i.txt
    let it++
}

cd CityBench
it=0
cdir=$(pwd | sed "s%/%\\\/%g")
for i in ${queries[@]}; do
    for duplicate in ${duplicates[@]}; do
        for frequency in ${frequencies[@]}; do
            for engine in ${engines[@]}; do
                if [ "$engine" = "querystreamer" ]; then
                    for annotation in ${annotations[@]}; do
                        for interval in ${intervals[@]}; do
                            for caching in ${cachings[@]}; do
                                echo "[$it/$nr]" "Query:" $i " Engine:" $engine " Duplicates:" $duplicate " Frequency:" $frequency " Annotation:" $annotation " Intervals:" $interval " Caching: " $caching
                                cat querystreamer.properties_template \
                                    | sed "s/TODO:tpfStreamingExec/$cdir\/..\/TPFStreamingQueryExecutor\//" \
                                    | sed "s/TODO:ldfServerPath/$cdir\/..\/TPFStreamingQueryExecutor\/node_modules\/ldf-server\//" \
                                    | sed "s/TODO:type/$annotation/" \
                                    | sed "s/TODO:interval/$interval/" \
                                    | sed "s/TODO:caching/$caching/" \
                                    | sed "s/debug = false/debug = true/" \
                                    > querystreamer.properties
                                runjar
                            done
                        done
                    done
                else
                    echo "[$it/$nr]" "Query:" $i " Engine:" $engine " Duplicates:" $duplicate " Frequency:" $frequency
                    runjar
                fi
            done
        done
    done
done
