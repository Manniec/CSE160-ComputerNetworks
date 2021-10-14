# Tasks
[] Flooding Module to Node Module
- [ ] Create flooding module and config file
- [ ] Add interface Flooding and Neighbor to Node Module file
- [ ] Specify config file for flooding module in Node Config
[] Neighbor task

## NESC
Tasks consist of 2 files
 - Module File (naming convention => TaskP.nc)
 - Configuration File (naming convention => TaskC.nc)

Module Files consist of 3 sections
- include statements (dependencies)
- Module block
- implement block

Congigeration Files consist of 3 sections
- include statements (dependencies)
- Config block
- Implement block

To wire a module you need to do these things
1. Add it as an interface under module file
2. Add it as a component in implementation of config file
3. Wire module's interface to its config file

# Project 1: Flooding

## Flooding

### Concept

For a node to flood a packet, the packet needs the following information:
- **source address:** the node initiating the flood; global source of packet
- **sequence number:** monotonically increasing unique identifier
- **TTL:** time to live, decrements at each hop to prevent packets from looping forever
- **(local) source address:** which immediate neighbor did the node receive the packet from?
- **(local) destination address:** node receiving packet at this hop

Nodes also need to recognize duplicate packets, and old packets to prevent looping/resending them. Nodes need to remember the latest packet's:
- **(global) source address:** packets from same source with same seq number shouldn't be rebroadcast (its a duplicate)
- **sequence number:** because its a monotonically increasing unique id, new packet sequence numbers should always be >= the last one; prevents node from forwarding same packet twice


Two ways to think about flooding a packet to all your neighbors:

1. **Send wirelessly:** wireless is already a *broadcast medium* so you can sent a packet once to everyone and whoever hears you & replys is a neighbor.
2. **Send wired:** send a copy of the packet more than to each of your known neighbors serially (needs neighbor discovery)

> Flooding vs Neighbor Discovery:
> Flooding is global. Its for when you would like a message to reach every other node in the system. Neighbor discovery is local (at the node level) when a node wants to send a message to only the nodes immediately surrounding it


### Implementation

**Flooding Packet**
|Layer| In code Representation| Info |  |  |  |
|--- | --- | --- | ---| --- | --- |
| Applicaiton Payload  | *nx_uint8_t* variable in **packet.h** | Payload |
| Flooding Header | *pack* struct in **packet.h** | (global) source address | sequence number | TTL |
| Link Layer Header | *sendInfo* struct in **sendinfo.h** | (local) source address | (local) destination address |

**Node Table**
| Incode Representation | Info | |
|---|---|---|
| *Cache* Hashmap in **FloodingP.nc** | packet (global) source *as uint32_t* | packet sequence number *as uint16_t*

One entry per node in network. Fill table out as packets are received

## Neighbor Discovery
Nodes can die and links can degrade at any time, so neighbor discover needs to be run in the background sending neighbor discovery packets periodically. This helps react to:
- Dead nodes
- Degrading link quality (noise): seq number can identify missing packets; time between ping&reply tells u rtt

### Concept
To implement neighbor discovery, you need to differentiate neighbor discovery packets from normal ones. Packet headers need:
- **request or reply field:** 
- **sequence number:** monotonically increasing unique identifier
- **(local) source address:** hop to hop link layer

Neighbor table



# Introduction
This skeleton code is the basis for the CSE160 network project. Additional documentation
on what is expected will be provided as the school year continues.

# General Information
## Data Structures
There are two data structures included into the project design to help with the
assignment. See dataStructures/interfaces/ for the header information of these
structures.

* **Hashmap** - This is for anything that needs to retrieve a value based on a key.

* **List** - The list is design to have pushfront, pushback capabilities. For the most part,
you can stick with an array or even a QueueC (FIFO) which are more robust.

## General Libraries
/lib/interfaces

* **CommandHandler** - CommandHandler is what interfaces with TOSSIM. Commands are
sent to this function, and based on the parameters passed, an event is fired.
* **SimpleSend** - This is a wrapper of the lower level sender in TinyOS. The features
included is a basic queuing mechanism and some small delays to prevent collisions. Do
not change the delays. You can duplicate SimpleSendC to use a different AM type or
possibly rewire it.
* **Transport** - There is only the interface of Transport included. The actual
implementation of the Transport layer is left to the student as an exercise. For
CSE160 this will be Project 3 so don't worry about it now.

## Noise
/noise/

This is the "noise" of the network. A heavy noised network will cause issues with
packet loss.

* **no_noise.txt** - There should be no packet loss using this model.

## Topography
/topo/

This folder contains a few example topographies of the network and how they are
connected to each other. Be sure to try additional networks when testing your code
since additional ones will be added when grading.

* **long_line.topo** - this topography is a line of 19 motes that have bidirectional
links.
* **example.topo** - A slightly more complex connection

Each line has three values, the source node, the destination node, and the gain.
For now you can keep the gain constant for all of your topographies. A line written
as ```1 2 -53``` denotes a one-way connection from 1 to 2. To make it bidirectional
include also ```2 1 -53```.

# Running Simulations
The following is an example of a simulation script.
```
from TestSim import TestSim

def main():
    # Get simulation ready to run.
    s = TestSim();

    # Before we do anything, lets simulate the network off.
    s.runTime(1);

    # Load the the layout of the network.
    s.loadTopo("long_line.topo");

    # Add a noise model to all of the motes.
    s.loadNoise("no_noise.txt");

    # Turn on all of the sensors.
    s.bootAll();

    # Add the main channels. These channels are declared in includes/channels.h
    s.addChannel(s.COMMAND_CHANNEL);
    s.addChannel(s.GENERAL_CHANNEL);

    # After sending a ping, simulate a little to prevent collision.
    s.runTime(1);
    s.ping(1, 2, "Hello, World");
    s.runTime(1);

    s.ping(1, 10, "Hi!");
    s.runTime(1);

if __name__ == '__main__':
    main()
```
