## What we Track

Currently we monitor a subset of the overall system statistics. 

- **System** tracks the monitoring VM and ALM VM health. 
- **ALM** tracks ALM specific stats and general JVM stats. 
- **JMX Bridge** tracks general JMX Bridge health. JMX-Bridge publishes stastics from ALM, SOLR and Analytics. 
- **SOLR** tracks the JVM used by the search service. 
- **Analytics** tracks the JVM used by the analytics service. 


## Interpreting the Graphs

Graphs will begin to display as the metrics are received. 

Some of the most useful System metrics are

- Load Average which shows how much of the system is utilized.
- Memory used which shows available RAM.

Some of the most useful ALM statistics are

- JDK 6 Memory which shows the memory used in the JVM.
- Jetty 8 Request Rate which shows average response time for requests.

JMX-Bridge metrics are primarily used internally.

For both SOLR and Analtyics the most importmant metric is JVM Memory.


## Time Frames for Graphs

You can view each set of Graphs  using different time frames such as  1 Hour, 2 Hours or 1 Month. 

## Snapshotting

The Rally GDash application contains the ability to snapshot your current graphs. This will create an archive of all your current graphs. You can then send this to Rally support for analysis. 

The tools to view the snapshot are only available to Rally support. 

