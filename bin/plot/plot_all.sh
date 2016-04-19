#!/bin/bash
d="output/"
./create_all_averaged.sh $d
./create_completeness.sh $d
./create_completeness_scalability.sh $d
./create_minmaxed.sh $d
