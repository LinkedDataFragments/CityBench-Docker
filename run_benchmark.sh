#!/bin/bash
duration="15m"
duration="1m" # For debugging
queries=(1 2 3 6 9 10 11)
engines=(querystreamer cqels csparql)
duplicates=(1 20 50)
frequencies=(1 0.1 0.01)
annotations=(reification singletonproperties graphs implicitgraphs)

nr=$(echo "${#queries[@]} * ${#engines[@]} * ${#duplicates[@]} * ${#frequencies[@]} * ${#annotations[@]}" | bc -l)

cd CityBench
it=0
for i in ${queries[@]}; do
    for engine in ${engines[@]}; do
        for duplicate in ${duplicates[@]}; do
            for frequency in ${frequencies[@]}; do
                for annotation in ${annotations[@]}; do
                    echo "[$it/$nr]" "Query:" $i " Engine:" $engine " Duplicates:" $duplicate " Frequency:" $frequency " Annotation:" $annotation
                    cdir=$(pwd | sed "s%/%\\\/%g")
                    cat querystreamer.properties_template \
                        | sed "s/TODO:tpfStreamingExec/$cdir\/..\/TPFStreamingQueryExecutor\//" \
                        | sed "s/TODO:ldfServerPath/$cdir\/..\/TPFStreamingQueryExecutor\/node_modules\/ldf-server\//" \
                        | sed "s/TODO:type/$annotation/" \
                        | sed "s/debug = true/debug = true/" \
                        > querystreamer.properties
                    cat querystreamer.properties # TODO: debug
                    java -jar build/libs/CityBench-all-1.0.0.jar rate=1.0 frequency=$frequency duration=$duration queryDuplicates=$duplicate startDate=2014-08-11T11:00:00 endDate=2014-08-31T11:00:00 engine=$engine query=Q$i.txt
                    let it++
                done
            done
        done
    done
done
