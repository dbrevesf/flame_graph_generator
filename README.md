# FlowGraph Generator for Java

## Dependencies

To use the `generate_flame_graph.sh` script you'll need to have: 

- linux `perf` 
- `perf-map-agent`
- and, obviousey, teh`FlameGraph`.


**Both `perf-map-agent` and `FlameGraph` repositories must be cloned at the root
directory of this repository.**


### Linux `perf`

If you still don't have it installed, you can install it through:

```
sudo apt install linux-tools-generic
```


### perf-map-agent

You can clone the repository https://github.com/jvm-profiling-tools/perf-map-agent
and follow the instructions located on its readme.


### FlameGraph

You can clone the repository https://github.com/brendangregg/FlameGraph


## Generating the FlameGraph

Besides that, you must run some Java application, preferably using the 
following command:

```
java -XX:+PreserveFramePointer -jar <application.jar> 
```

Once it's running, you can retrieve the PID executing the following command:

```
pgrep java
```

You can have more than one PID related to other Java applications running 
concurrently, so you can run the `pgrep java` before and after running your
Java application so you can know exactly which PID is the correct one.

With the Java Application running and the PID, you can generate the FlameGraph 
executing the following command:

```
./generate_flame_graph <PID> <name> <time_to_perf: optional> 
```

where PID is the PID retrieved above, name is an arbitrary string for the 
SVG file that will be generated and you can also set the time to execute the `perf`
which is a integer value for the amount of seconds. The default is 10 seconds. 

The FlameGraph will be located at the root directory, with SVG extension and can be openned 
in a browser.


## Links

- https://www.brendangregg.com/flamegraphs.html
- https://www.youtube.com/watch?v=ugRrFdda_JQ
- https://maheshsenniappan.medium.com/java-performance-profiling-using-flame-graphs-e29238130375

