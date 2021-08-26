#!/bin/bash

set -e
if [[ $1 -eq 0 ]] || [[ $2 = "" ]] ; then
    echo 'You must pass two arguments: PID, a name for the FlameGraph SVG file and optionally a value for the amount of seconds which the perf will be executed.'
    echo 'Example: ./generate_flame_graph 2112 FirstFlameGraph 20'
    exit 1
fi

TIME=10
if [[ $3 -ne 0 ]]; then
    TIME=$3
fi
echo "- executing perf for $TIME seconds, for the process: $1"
sudo perf record -F 99 -p $1 -g sleep $TIME
echo "- creating java perf map"
./perf-map-agent/bin/create-java-perf-map.sh $1
echo "- generating out.perf"
sudo perf script > out.perf
echo "- collapsing the stack trace"
./FlameGraph/stackcollapse-perf.pl out.perf > out.folded
echo "- generating flame graph on: $2.svg"
./FlameGraph/flamegraph.pl out.folded > $2.svg
echo "- removing perf files"
sudo rm *.perf *.data *.folded

