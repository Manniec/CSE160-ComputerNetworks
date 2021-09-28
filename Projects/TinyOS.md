# TinyOS Notes
## What is TinyOS?
A small operating system designed for use with sensor networks in ambient intelligence systems. Because it is designed for event centric networks of small computers (with limits on size, cost, and power concumption) its accounts for:

1. Limited memory and computing power
2. Reactive Concurrency management
3. Variation in hardware & application
4. Low power

## Event driven concurrency
There are 3 computational abstractions

1. **commands:** responsive inter-component communication; requests to a component to do something; downcalls
2. **events:**  responsive asynchronous inter-component communicaiton; signals a command service has been completed; upcalls
3. **tasks:** deffered computaton, for intra-component concurrency; for extensice computation tasks. May only access state within component