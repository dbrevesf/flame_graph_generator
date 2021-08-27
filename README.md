# FlowGraph Generator for Java

This repository contains a script to generate a FlameGraph of a Java application through the stack trace obtained through the perf, which is a performance analysing tool in Linux. It's also using the `perf-map-agent` which is a java agent to generate `/tmp/perf-<pid>.map` files for just-in-time(JIT)-compiled methods.

## Generating the FlameGraph

First of all, you must run the Java application that you would like to profile, preferably using the 
following command:

```
java -XX:+PreserveFramePointer -jar <application.jar> 
```

The `-XX:+PreserveFramePointer` argument is used to provide information to the debuggers about the call stack. 
With this option set, perf can construct more accurate stack traces by using information in the frame pointer 
about the currently executing method. 

Once it's running, you'll need the application PID. One way you can get it is executing the following command:

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
 
