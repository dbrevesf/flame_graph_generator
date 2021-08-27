#!/bin/bash

set -e

if ! command -v perf &> /dev/null
then
    echo "perf could not be found. You can install it executing:"
    echo "sudo apt install linux-tools-generic "
    exit
fi


PERF_MAP_AGENT=perf-map-agent
if [[ ! -d "$PERF_MAP_AGENT" ]];
then
     echo "perf-map-agent could not be found. You can download it executing:"
     echo "git clone git@github.com:jvm-profiling-tools/perf-map-agent.git"
     exit
fi


PERF_MAP_AGENT_OUT=perf-map-agent/out
if [[ ! -d "$PERF_MAP_AGENT_OUT" ]]; 
then
    echo "The perf-map-agent binaries could not be found. You can build it executing:"
    echo "cd /perf-map-agent"
    echo "cmake ."
    echo "make"
    exit
fi   

FLAME_GRAPH=FlameGraph
if [[ ! -d "$FLAME_GRAPH" ]]; 
then
    echo "FlameGraph could not be found. You can download it executing:"
    echo "git clone git@github.com:brendangregg/FlameGraph.git"
    exit
fi   


if [[ $1 -eq 0 ]] || [[ $2 = "" ]] ; then
    echo 'You must pass two required arguments: PID, a name for the FlameGraph SVG file and, optionally, a value for the period in seconds which the perf will be executed.'
    echo 'Example: ./generate_flame_graph 2112 FirstFlameGraph 20'
    exit 1
fi

TIME=10
CREATE_JAVA_PERF=perf-map-agent/bin/create-java-perf-map.sh
if [[ $3 -ne 0 ]]; then
    TIME=$3
fi

echo "- executing perf for $TIME seconds, for the process: $1"
sudo perf record -F 99 -p $1 -g sleep $TIME
echo "- creating java perf map"
./$CREATE_JAVA_PERF $1
echo "- generating out.perf"
sudo perf script > out.perf
echo "- collapsing the stack trace"
./$FLAME_GRAPH/stackcollapse-perf.pl out.perf > out.folded
echo "- generating flame graph on: $2.svg"
./$FLAME_GRAPH/flamegraph.pl out.folded > $2.svg
echo "- removing perf files"
sudo rm *.perf *.data *.folded

