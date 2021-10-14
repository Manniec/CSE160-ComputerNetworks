//---INCLUDE---//

#include "../../includes/channels.h"
#include "../../includes/neighborStats.h"

//---MODULE---//
module NeighborDiscoverP{

    //PROVIDES

    //specify Flooding task as an interface (so Node Module can call it)
    provides interface NeighborDiscover;

    //USES
    uses interface Hashmap<neighborStats> as NeighborsTable; //table of nodes with time value

    uses interface Timer<TMilli> as requestTimer;

    uses interface List<uint32_t> as NeighborsList;

    uses interface Flooding; //to check cache

    uses interface Receive;

    uses interface SimpleSend as Sender;
    
}

//---IMPLEMENTATION---//
implementation{

    uint16_t neighborThreshold = 60; // Must receive over 60% of pings to be considered a neighbor
    neighborStats newInfo;
    neighborStats oldInfo;

    uint16_t numPacketsLost = 0;

    pack neighborRequest;

    // Define functions
    bool isValidNeighbor(neighborStats stats);
    uint16_t countLostPackets(uint16_t node, uint16_t currentSeqNum);
    void updateNodeStats(uint16_t neighbor, uint16_t received, uint16_t sent);
    task void requestNeighbors();
    task void respondToNeighbors();
    void makeNeighborRequestPack(pack * myRequest);

    //Begin or Initialize Neighbor Discovery
    command void NeighborDiscover.start(){
        call requestTimer.startPeriodic(30000);
    }

    //When timer goes off
    event void requestTimer.fired(){
        post requestNeighbors();
        dbg(NEIGHBOR_CHANNEL, "Repinging Neighbor Discovery");
    }

    //Broadcast a Neighbor Discovery Packet
    task void requestNeighbors(){
        makeNeighborRequestPack(&neighborRequest);
        call Sender.send(neighborRequest, AM_BROADCAST_ADDR);
    }

    // Receive Neighbor Discovery packets
    event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len){
        if(len==sizeof(pack)){
            pack* myMsg=(pack*) payload; 
            // Receiving a neighbor's request
            if(myMsg->dest == AM_BROADCAST_ADDR){
                dbg(NEIGHBOR_CHANNEL, "Neighbor Packet %s Received\n", myMsg->seq);
                makeNeighborResponse(&myMsg);
                post respondToNeighbors();
            // Receiving a neighbors response
            }else if ((myMsg->dest == TOS_NODE_ID) && (myMsg->protocol == 1)){
                dbg(NEIGHBOR_CHANNEL, "Neighbor Response Packet %s Received \n", myMsg->seq );
            }

        } else if (len == sizeof(sendInfo)){
            sendInfo* myMsg=(sendInfo*) msg; 
            dbg(NEIGHBOR_CHANNEL, "Packet is sendINfo");
        } else{
            dbg(NEIGHBOR_CHANNEL, "Not a packet");
        }
        
    }

    task void respondToNeighbors(){
        dbg(NEIGHBOR_CHANNEL, "respond to neighbor %s", myRequest->src)
    }

    void makeNeighborRequestPack(pack * myRequest, uint8_t* payload){
        myRequest->src = TOS_NODE_ID;
        myRequest->dest = AM_BROADCAST_ADDR;
        myRequest->TTL = 2;
        myRequest->protocol = 0;
    }

    void makeNeighborResponse (pack* myRequest){
        myRequest->src = TOS_NODE_ID;
        myRequest->dest = requestSrc;
        myRequest->TTL = 2;
        myRequest->protocol = 1; //Ping Reply protocol
    }

    // Update Neighbor Table Statistics
    command void NeighborDiscover.updateNeighborsTable(uint32_t srcNode, uint16_t newSeqNum){
        
        // Save Node & sequence number to cache
        call Flooding.addToCache(srcNode, newSeqNum);

        // Check for dropped packets
        numPacketsLost = countLostPackets(srcNode, newSeqNum);
        if( numPacketsLost > 0){
            // Add 1 to # received & add difference between 2 sequenceNums to sent
            updateNodeStats(srcNode, 1, numPacketsLost);

        }else{ // If no lost packets, increment #received & #sent by 1
            updateNodeStats(srcNode, 1, 1);
        }
    }

    command uint32_t* NeighborDiscover.getNeighbors(){
        return call NeighborsTable.getKeys();
    }

    command uint16_t NeighborDiscover.getNeighborsCount(){
        return call NeighborsTable.size();
    }

    // Checks current packet's sequence number against previous packets from this node & returns the difference
    uint16_t countLostPackets(uint16_t node, uint16_t currentSeqNum){
        uint16_t oldSeqNum = call Flooding.getLastSeq(node);
        return (currentSeqNum - oldSeqNum);
    }

    void updateNodeStats(uint16_t node, uint16_t received, uint16_t sent){

        // Check if node is new
        if (! call NeighborsTable.contains(node)){ 
            
            // If Node not in table yet -> create new entry
            newInfo.receivedCount = received;
            newInfo.sentCount = sent;

        } else { 
            
            // Update existing node info
            oldInfo = call NeighborsTable.get(node);
            newInfo.receivedCount = oldInfo.receivedCount + received;
            newInfo.sentCount = oldInfo.sentCount + sent;

            //Delete old info
            call NeighborsTable.remove(node);

        }

        //Inactive neighbors dont get added back to the table
        if (isValidNeighbor(newInfo)){
            call NeighborsTable.insert(node, newInfo);
        }
        
    }

    // Compare percent of recieved replys against neighborThreshold
    bool isValidNeighbor(neighborStats stats){
        if (((stats.receivedCount * 100) / stats.sentCount) > neighborThreshold){
            return TRUE;
        }
        return FALSE;
    }

    //event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len){
    //    // Check if message is a neighbor discovery ping
    //    if(len == sizeof(sendInfo)){
    //        sendInfo* myMsg = (sendInfo*) payload;
    //
    //        // Receive Neighbor request
    //        if (myMsg->protocol){
    //            
    //
    //        // Receive Neighbor Reply
    //        } else if(myMsg->protocol == 1)){
    //            dbg(NEIGHBOR_CHANNEL, "Neighbor node %s reply received... \n")
    //        }
    //    }else{
    //        dbg(NEIGHBOR_CHANNEL, "unknown packet type")
    //    }
    //}

}